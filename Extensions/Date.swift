//
//  Date.swift
//  Simplytics
//
//  Created by Quinton Wall on 12/6/17.
//

import Foundation

public extension Date {
    
    private struct Static {
        static var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
            return formatter
        }()
    }
    
    public func toRFC3339String() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
        return formatter.string(from: self)
    }
    
    public func toISO8601String() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter.string(from: self)
    }
    
    public static func dateFromRFC3339String(string: String) -> Date? {
        return dateFromString(dateString: string, withFormat: "yyyy-MM-dd'T'HH:mm:ss.S'Z'")
    }
    
    public func toPrettyString() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "E MMM dd, yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }
    
    public func toDateTimeStringWithSeconds() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    public func toShortPrettyString() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: self)
    }
    public func toShortMMMString() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "dd-MMM-yy"
        return formatter.string(from: self)
    }
    
    public func toMonthYearString() -> String {
        let formatter = Static.formatter
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: self)
    }
    
    public static func dateFromString(dateString: String, withFormat format: String) -> Date? {
        let formatter = Static.formatter
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
    public func beginningOfDay() -> Date {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    public func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        
        var date = Calendar.current.date(byAdding: components, to: self.beginningOfDay())!
        date = date.addingTimeInterval(-1)
        return date
    }

        var millisecondsSince1970:Int {
            return Int((self.timeIntervalSince1970 * 1000.0).rounded())
        }
        
        init(milliseconds:Int) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
        }
    
}
