//
//  AppDelegate.swift
//  Vanilla
//
//  Created by Hend  on 8/26/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Spoonacular.sharedInstance().favRecipes = UserDefaults.standard.value(forKey: "favRecipes") as? [String : Date] ?? [String:Date]()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(Spoonacular.sharedInstance().favRecipes, forKey: "favRecipes")
    }


}

