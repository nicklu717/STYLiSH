//
//  TabBarController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/26.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        let cartProductList = StorageManager.sharedInstance.cartProductList
        
        for navigationViewController in viewControllers where navigationViewController is CartNavigationController {
            
            guard
                let cartNavigationController = navigationViewController as? CartNavigationController
            else {
                return
            }
            
            cartNavigationController.cartNavigationTabBarItem.badgeValue = "\(cartProductList.count)"
                
            for viewController in cartNavigationController.viewControllers where viewController is CartViewController {

                guard
                    let cartViewController = viewController as? CartViewController
                else {
                    return
                }
                
                NotificationCenter.default.addObserver(
                    cartViewController,
                    selector: #selector(cartViewController.changeBadgeValue(notification:)),
                    name: .cartProductListDidChandge,
                    object: nil
                )
                
                cartViewController.loadView()
                
                if StorageManager.sharedInstance.cartProductList.count == 0 {
                    cartViewController.goToPayButton.isHidden = true
                } else {
                    cartViewController.goToPayButton.isHidden = false
                }
                
                cartViewController.tableView.dataSource = cartViewController
                
                NotificationCenter.default.addObserver(
                    cartViewController,
                    selector: #selector(cartViewController.reloadTableView(notification:)),
                    name: .cartProductListDidChandge,
                    object: nil
                )
            }
        }
    }
}
