//
//  AppDelegate.swift
//  Simplytics
//
//  Created by quintonwall on 11/23/2017.
//  Copyright (c) 2017 quintonwall. All rights reserved.
//

import UIKit
import Simplytics
import SwiftlySalesforce

var salesforce: Salesforce!
var simplytics: Simplytics!


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginDelegate {

    var window: UIWindow?
    var appeventid : String = ""
    
    //salesforce connection config
    let consumerKey = "ADD-YOUR-CONSUMER-KEY"
    let callbackURL = URL(string: "ADD-YOUR-CALLBACK-URL-FROM-CONNECTED-APP")!
    let hostname = "ADD-YOUR-POD.lightning.force.com"
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure SwiftlySalesforce
        salesforce = configureSalesforce(consumerKey: consumerKey, callbackURL: callbackURL, loginHost: hostname)
        simplytics = Simplytics()
        simplytics.logApp(Bundle.main.bundleIdentifier!)
        appeventid = simplytics.logEvent("App Active")
        print("APPEVENTID: \(appeventid)")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handleCallbackURL(url, for: salesforce.connectedApp)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // each time the app goes into the background we end the App Active event. What this means is that logged app duration will be total time the app process is running, not just when the app is active.
       simplytics.endEvent(appeventid)
       simplytics.writeToSalesforce(salesforce)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       // simplytics.writeToSalesforce(salesforce)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
       //example of tracking active duration of entire app
        
        //NOTE: Salesforce does not allow writes when the app is in the background. Adding any calls here to simplytics.writeToSalesforce will fail.
    }


}

