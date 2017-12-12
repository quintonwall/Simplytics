# Simplytics

[![CI Status](http://img.shields.io/travis/quintonwall/Simplytics.svg?style=flat)](https://travis-ci.org/quintonwall/Simplytics)
[![Version](https://img.shields.io/cocoapods/v/Simplytics.svg?style=flat)](http://cocoapods.org/pods/Simplytics)
[![License](https://img.shields.io/cocoapods/l/Simplytics.svg?style=flat)](http://cocoapods.org/pods/Simplytics)
[![Platform](https://img.shields.io/cocoapods/p/Simplytics.svg?style=flat)](http://cocoapods.org/pods/Simplytics)

Simplytics is a lightweight logging framework for iOS apps which use Salesforce as a backend. You can log app details like build number, device, and OS version, or in-app events like buttons tapped, tables selected, and duration of things like how long a user was on a particular screen. How you use Simplytics is up to you. Its small, lightweight, and efficient. It is designed to be simple to use, thus the name Simplytics.

```swift
  simplytics.logEvent("Simplytics is awesome", funnel: "ShoppingCart")
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Mobile App Setup
V1 relies on SwiftlySaleforce for authentication to salesforce. Support for the Salesforce Mobile SDK will come shortly with a refactor to the auth config. For now, setting up Simplytics should be handled directly after the SwiftlySalesforce config in the didFinishLauchingWithOptions func of your AppDelegate:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Configure SwiftlySalesforce
    salesforce = configureSalesforce(consumerKey: consumerKey, callbackURL: callbackURL, loginHost: hostname)
    // Initialize Simplytics
    simplytics = Simplytics()
    //then log app
    simplytics.logApp(Bundle.main.bundleIdentifier!)
    return true
}
```
### Offline Optimization
You will notice that the example above also logs the app directly after instantiating Simplytics, and before any sort of successful authentication into Salesforce.  Simplytics works entirely offline, using a local Realm database, to store event information. This allows extremely fast writes, a greatly reduced likelihood of loosing any events due to app crashes, and highly efficient use of network calls to salesforce for logging event data. Simplytics leaves when to write events to Salesforce up to the discretion of the developer.


### Writing to Salesforce
To write events to Salesforce is via the writeToSalesforce func, which accepts an authenticated SwiftlySalesforce instance.

```swift
simplytics.writeToSalesforce(salesforce)
```

The easiest, and most efficient way to  write events is by adding calls to simplytics within your AppDelegate lifecycle events, applicationWillResignActive and/or applicationWillTerminate. This allows batching writes to save Salesforce API calls, and performs the (async) network operation when the user isn't actively using your app. The result is users will never see any performance impact on your app experience.

```swift
func applicationWillResignActive(_ application: UIApplication) {
    simplytics.writeToSalesforce(salesforce)
}
```

For a complete example of configuring Simplytics, check out the AppDelegate in the sample app.

## Salesforce Setup



## Installation

Simplytics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Simplytics'
```

## Author

quintonwall, qwall@salesforce.com

## License

Simplytics is available under the MIT license. See the LICENSE file for more info.
