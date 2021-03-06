//
//  AppDelegate.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast

    static let shared = UIApplication.shared.delegate as! AppDelegate

    // swiftlint:enable force_cast
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {

        IQKeyboardManager.shared().isEnabled = true

        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        HCFirebaseManager.shared.configure()
        
        Fabric.with([Crashlytics.self])
        
        setNavBar()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

extension AppDelegate {
    
    func setNavBar() {
    
        let font = UIFont.boldSystemFont(ofSize: 14)
        
        //        let font = UIFont(name: "SF Mono", size: 13) ?? UIFont.boldSystemFont(ofSize: 13)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: font]
    }
}
