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

An example app is included which demonstrates typical configuration and usage patterns of Simplytics. At a high level, you can breakdown the app into the following sections.

* Configuration
Check out AppDelegate.swift for how to instantiate Simplytics.

* Contact List
An example of using Simplytics with Salesforce data.

* Featured View
An example of a funnel consisting of multiple screens and tracking app navigation.

<img src="https://github.com/quintonwall/Simplytics/blob/master/readme-assets/sample-app.png?raw=true" width=500/>

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### CocoaPods
Simplytics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Simplytics'
```

### Salesforce

## Setup

### Mobile App
V1 relies on [SwiftlySaleforce](https://github.com/mike4aday/SwiftlySalesforce) for authentication to salesforce. Support for the Salesforce Mobile SDK will come shortly with a refactor to the auth config. For now, setting up Simplytics should be handled directly after the SwiftlySalesforce config in the didFinishLauchingWithOptions func of your AppDelegate:

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
#### Offline Optimization
You will notice that the example above also logs the app directly after instantiating Simplytics, and before any sort of successful authentication into Salesforce.  Simplytics works entirely offline, using a local Realm database, to store event information. This allows extremely fast writes, a greatly reduced likelihood of loosing any events due to app crashes, and highly efficient use of network calls to salesforce for logging event data. Simplytics leaves when to write events to Salesforce up to the discretion of the developer.


#### Writing to Salesforce
To write events to Salesforce is via the writeToSalesforce func, which accepts an authenticated SwiftlySalesforce instance.

```swift
simplytics.writeToSalesforce(salesforce)
```

The easiest, and most efficient time to write events is by adding calls to simplytics within your AppDelegate lifecycle event, applicationWillResignActive and/or applicationWillTerminate. This allows batching writes to save Salesforce API calls, and performs the (async) network operation when the user isn't actively using your app. The result is users will never see any performance impact on your app experience. Of course, you can call writeToSalesforce any time you like, as long as you have already authenticated into salesforce.

```swift
func applicationWillResignActive(_ application: UIApplication) {
    simplytics.writeToSalesforce(salesforce)
}
```
It is important to note that, for security and policy reasons,  Salesforce does not allow API calls when an app is running in the background.  This means that any call to writeToSaleforce within applicationWillTerminate will not be written until the next time the app runs and writeToSalesforce is called. Simplytics persistents all log events locally in a Realm database. This means that you will not loose any events logged when in the background, but you can not persist an eventid across app sessions. In other words, you cant call endEvent and correctly have event duration calculated.

For a complete example of configuring Simplytics, including how to log app active duration, check out the AppDelegate in the sample app.

### Salesforce
Install the following unmanaged package into your Salesforce org. This will create the require custom objects where events are stored, an ApexRest service used to post events to Salesforce, and a collection of reports to track mobile app usage.

TODO: add package install

## Usage
### Mobile App

#### Log an event
Events are logged using the logEvent function:

```swift
logEvent(_ event: String, funnel:String?="", withProperties properties: [String: String]?=nil)
```

The most basic form of event log accepts an event name, for example if you want to log when a screen is loaded:

```swift
 simplytics.logEvent("View shopping cart")
```

Generally, you want to also include the event in a funnel to track a particular use case or app flow such as on-boarding, check-out etc. A funnel is simply a name which can be used later within Salesforce to report upon.

```swift
simplytics.logEvent("Added Credit Card", funnel: "Checkout")
```

### Events with properties
To add additional information to an event log, you can pass in a Dictionary  object. This is especially useful if you want to include contextual information. For example, if your app includes a list of Contact records from Salesforce you want to log whenever a user selects a row in a table, and which contact record they selected.

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
    simplytics.logEvent("Selected Table Row", funnel: "Contacts", withProperties: ["Contact Selected" : cell.contactid!])
}
```

### Timed events
There are times where you want to track duration of user activity within your app, or general app analytics. For example, how long a network operation takes, or how long a user remains on a screen. To achieve this, call endEvent, passing in the event id. The example below creates an event when a view becomes active and then ends the event when a seque is called navigating the user away. The example also adds another event to capture the from-to navigation details to assist in understand user activity and flow within your app.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    eventid = simplytics.logEvent("Featured View screen Loaded", funnel: "Featured")
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    simplytics.logEvent("Navigation", funnel: "Featured", withProperties: ["From" : "FeaturedView", "To" : "Page2"])
    simplytics.endEvent(eventid)
}
```



### Salesforce
#### Object model
The Simplytics object model is pretty basic, consisting of three objects

* Simplytics_Application__c
Stores application level information. A new application record is written whenever a new version or build or your mobile application is created.

* Simplytics_Event__c
The event record created through logEvent. Events contain a master-detail relationship to Simplytics_Application__c

* Simplytics_EventProperty__c
The dictionary properies associated with an event

#### Reports
The following standard reports have been created to assist in tracking and reporting on mobile app activity. These are intended to be starting points for customization by your Salesforce Administrator.

* Mobile App Versions by Device
A report listing each mobile app version, grouped by which devices it is running on.
<img src="https://github.com/quintonwall/Simplytics/blob/master/readme-assets/report-versions.png?raw=true" width=500/>

* Mobile App Events by App by Device
A report listing all the events for each specific instance of the app. This is helpful especially if a customer is having an issue. You can request their UUID and filter events for that specific device.
<img src="https://github.com/quintonwall/Simplytics/blob/master/readme-assets/report-events.png?raw=true" width=500/>



## Author

quintonwall, hello@quinton.me

## License

Simplytics is available under the MIT license. See the LICENSE file for more info.
