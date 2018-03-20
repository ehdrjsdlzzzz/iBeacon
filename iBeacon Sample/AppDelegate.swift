//
//  AppDelegate.swift
//  iBeacon Sample
//
//  Created by 이동건 on 2018. 3. 19..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainVC())
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("-----Now in Inactive-----")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("-----Now in Background-----")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("-----Now in Foreground-----")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("-----Now in Active-----")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("-----Now in Terminate-----")
    }


}

