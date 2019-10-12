//
//  StorageManager.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/25.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import CoreData

class StorageManager {
    
    static let sharedInstance = StorageManager()
    
    var cartProductList: [CartProduct] = [] {
        
        didSet {
        
            NotificationCenter.default.post(
                name: .cartProductListDidChandge,
                object: nil,
                userInfo: [NotificationInfo.newCartProductList: cartProductList]
            )
            
            do {
                try StorageManager.sharedInstance.persistentContainer.viewContext.save()
                print("Data Save Succeed.")
            } catch let error as NSError {
                print("Failure in Saving Data. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "STYLiSH")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func clearCartProductList() {
        
        for cartProductObject in cartProductList {
            persistentContainer.viewContext.delete(cartProductObject)
        }
        
        cartProductList = []
    }
}
