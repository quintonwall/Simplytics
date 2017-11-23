//
//  Resource.swift
//  SwiftlySalesforce
//
//	For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2017. All rights reserved.
//

public enum Resource {
	case identity(version: String)
	case limits(version: String)
	case query(soql: String, version: String)
	case queryNext(path: String)
	case retrieve(type: String, id: String, fields: [String]?, version: String)
	case insert(type: String, data: Data, version: String)
	case update(type: String, id: String, data: Data, version: String)
	case delete(type: String, id: String, version: String)
	case describe(type: String, version: String)
	case describeGlobal(version: String)
	case fetchFile(baseURL: URL?, path: String?, contentType: String)
	case registerForNotifications(deviceToken: String, version: String)
	case apex(method: HTTPMethod, path: String, queryParameters: [String: Any?]?, data: Data?, headers: [String: String]?)
	case custom(method: HTTPMethod, baseURL: URL?, path: String?, queryParameters: [String: Any?]?, data: Data?, headers: [String: String]?)
	case revoke(token: String, host: String)
	case refresh(refreshToken: String, consumerKey: String, host: String)
}

public extension Resource {
	
	public enum HTTPMethod: String {
		case options = "OPTIONS"
		case get     = "GET"
		case head    = "HEAD"
		case post    = "POST"
		case put     = "PUT"
		case patch   = "PATCH"
		case delete  = "DELETE"
		case trace   = "TRACE"
		case connect = "CONNECT"
	}
}

internal extension Resource {
	
	fileprivate enum ContentType: String {
		case json = "application/json"
		case urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
	}
	
	internal func asURLRequest(authData: OAuth2Result) throws -> URLRequest {
		
		switch self {
			
		case let .identity(version):
			let url = authData.identityURL
			let params = ["version" : version]
			return try URLRequest(url: url, authData: authData, queryParameters: params, httpMethod: .get, contentType: .urlEncoded)
			
		case let .limits(version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/limits")
			return try URLRequest(url: url, authData: authData, httpMethod: .get, contentType: .urlEncoded)

		case let .query(soql, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/query")
			let params = ["q" : soql]
			return try URLRequest(url: url, authData: authData, queryParameters: params, httpMethod: .get, contentType: .urlEncoded)
			
		case let .queryNext(path):
			let url = authData.instanceURL.appendingPathComponent(path)
			return try URLRequest(url: url, authData: authData, httpMethod: .get, contentType: .urlEncoded)
			
		case let .retrieve(type, id, fields, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/\(type)/\(id)")
			let params: [String: Any]? = {
				if let fieldNames = fields?.joined(separator: ",") { return ["fields": fieldNames] }
				else { return nil }
			}()
			return try URLRequest(url: url, authData: authData, queryParameters: params, httpMethod: .get, contentType: .urlEncoded)
			
		case let .insert(type, data, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/\(type)/")
			return try URLRequest(url: url, authData: authData, httpBody: data, httpMethod: .post, contentType: .json)
			
		case let .update(type, id, data, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/\(type)/\(id)")
			return try URLRequest(url: url, authData: authData, httpBody: data, httpMethod: .patch, contentType: .json)

		case let .delete(type, id, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/\(type)/\(id)")
			return try URLRequest(url: url, authData: authData, httpMethod: .delete, contentType: .urlEncoded)
			
		case let .describe(type, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/\(type)/describe")
			return try URLRequest(url: url, authData: authData, httpMethod: .get, contentType: .urlEncoded)
			
		case let .describeGlobal(version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/")
			return try URLRequest(url: url, authData: authData, httpMethod: .get, contentType: .urlEncoded)

		case let .fetchFile(baseURL, path, contentType):
			var url = (baseURL ?? authData.instanceURL)
			if let path = path {
				url.appendPathComponent(path)
			}
			return try URLRequest(url: url, authData: authData, headers: ["Accept": contentType], httpMethod: .get, contentType: .urlEncoded)
			
		case let .registerForNotifications(deviceToken, version):
			let url = authData.instanceURL.appendingPathComponent("/services/data/v\(version)/sobjects/MobilePushServiceDevice")
			let data = try JSONEncoder(dateFormatter: DateFormatter.salesforceDateTimeFormatter).encode(["ConnectionToken" : deviceToken, "ServiceType" : "Apple" ])
			return try URLRequest(url: url, authData: authData, httpBody: data, httpMethod: .post, contentType: .json)

		case let .apex(method, path, queryParameters, data, headers):
			let url = authData.instanceURL.appendingPathComponent("/services/apexrest\(path)")
			let contentType: ContentType = (data == nil ? .urlEncoded : .json)
			return try URLRequest(url: url, authData: authData, queryParameters: queryParameters, httpBody: data, headers: headers, httpMethod: method, contentType: contentType)
			
		case let .custom(method, baseURL, path, queryParameters, data, headers):
			var url: URL = (baseURL ?? authData.instanceURL)
			if let path = path {
				url.appendPathComponent(path)
			}
			let contentType: ContentType = (data == nil ? .urlEncoded : .json)
			return try URLRequest(url: url, authData: authData, queryParameters: queryParameters, httpBody: data, headers: headers, httpMethod: method, contentType: contentType)
			
		case let .revoke(token, host):
			guard let url = URL(string: "https://\(host)") else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSURLErrorFailingURLStringErrorKey: host])
			}
			let params = ["token": token]
			return try URLRequest(url: url, authData: authData, queryParameters: params, httpMethod: .get, contentType: .urlEncoded)

		case let .refresh(refreshToken, consumerKey, host):
			guard let url = URL(string: "https://\(host)") else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSURLErrorFailingURLStringErrorKey: host])
			}
			let params = [
				"format" : "urlencoded",
				"grant_type": "refresh_token",
				"client_id": consumerKey,
				"refresh_token": refreshToken]
			return try URLRequest(url: url, authData: authData, queryParameters: params, httpMethod: .get, contentType: .urlEncoded)
		}
	}
}

fileprivate extension URLRequest {
	
	fileprivate init(url: URL, authData: OAuth2Result, queryParameters: [String: Any?]? = nil, httpBody: Data? = nil, headers: [String: String]? = nil, httpMethod: Resource.HTTPMethod, contentType: Resource.ContentType) throws {
		
		// URL
		if let params = queryParameters {
			guard var _comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
			}
			_comps.queryItems = params.map {
				param in
				if let value = param.value {
					return URLQueryItem(name: param.key, value: "\(value)")
				}
				else {
					return URLQueryItem(name: param.key, value: nil)
				}
			}
			guard let _url = _comps.url else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
			}
			self.init(url: _url)
		}
		else {
			self.init(url: url)
		}
		
		// Standard headers
		self.setValue("Bearer \(authData.accessToken)", forHTTPHeaderField: "Authorization")
		self.setValue("application/json", forHTTPHeaderField: "Accept")
		self.httpMethod = httpMethod.rawValue
		self.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
		
		// Custom headers
		if let headers = headers {
			for header in headers {
				self.setValue(header.value, forHTTPHeaderField: header.key)
			}
		}
		
		// Body data
		self.httpBody = httpBody ?? nil
	}
}
