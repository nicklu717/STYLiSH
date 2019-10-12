//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import KeychainAccess
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
                        ) -> Bool {
        
//        Keychain(service: "com.wein7.STYLiSH")["User Token"] = nil
        
        TPDSetup.setWithAppId(12348, withAppKey: "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF", with: TPDServerType.sandBox)
        TPDSetup.shareInstance().setupIDFA(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        TPDSetup.shareInstance().serverSync()
        
        IQKeyboardManager.shared.enable = true
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let fetchRequest = NSFetchRequest<CartProduct>(entityName: "CartProduct")
        
        do {
            let cartContext = StorageManager.sharedInstance.persistentContainer.viewContext
            StorageManager.sharedInstance.cartProductList = try cartContext.fetch(fetchRequest)
            print("Data fetched.")
        } catch let error as NSError {
            print("Couldn't fetch cart product data. \(error), \(error.userInfo)")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContext(notification:)),
            name: .cartProductListDidChandge,
            object: nil
        )
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = ApplicationDelegate.shared.application(app, open: url, options: options)
        return result
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return result
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        let cartContext = StorageManager.sharedInstance.persistentContainer.viewContext
        
        do {
            try cartContext.save()
        } catch let error as NSError {
            fatalError("Unresolve error \(error), \(error.userInfo)")
        }
    }
    
    @objc func saveContext(notification: Notification) {
        
        let cartContext = StorageManager.sharedInstance.persistentContainer.viewContext
        
        do {
            try cartContext.save()
        } catch let error as NSError {
            fatalError("Unresolve error \(error), \(error.userInfo)")
        }
    }
}
