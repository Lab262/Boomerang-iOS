//
//  AppDelegate.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 10/7/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Fabric.with([Crashlytics.self])
        
         // URLS.setupBaseURL()
   
        
        Fabric.with([Crashlytics.self])
        
        self.window!.rootViewController = self.setInitialStoryboardBySeasonUser()
        
       // self.setupBarsAppearance()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "boomerangapi"
            $0.clientKey = ""
            $0.server = "http://boomerangapi.herokuapp.com/parse"
            
        }
        
        Parse.initialize(with: configuration)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

        
//        if DefaultsHelper.sharedInstance.email == ""  || DefaultsHelper.sharedInstance.email == nil {
//            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
//            let vcToShow = storyboard.instantiateInitialViewController()
//            self.window?.rootViewController = vcToShow
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vcToShow = storyboard.instantiateInitialViewController()
//            self.window?.rootViewController = vcToShow
//        }

        
        return true
        
      
    }

    
    func setInitialStoryboardBySeasonUser() -> UIViewController? {
        
        var initialViewController: UIViewController? = nil
        
        if PFUser.current() != nil {
            initialViewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Main", identifier: "")
            
        }else {
            
            initialViewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Authentication", identifier: "")
        }
        
        return initialViewController
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    
}

