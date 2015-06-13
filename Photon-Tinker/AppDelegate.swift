//
//  AppDelegate.swift
//  Photon-Tinker
//
//  Created by Ido on 4/16/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println(AppDelegate.getSSID())
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*
    class func getSSID() -> String {
        
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return ""
        }
        
        let interfacesArray = interfaces.takeRetainedValue() as! [String]
        if interfacesArray.count <= 0 {
            return ""
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
        if unsafeInterfaceData == nil {
            return ""
        }
        
        let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary!
        
        return interfaceData["SSID"] as! String
    }

*/

}

