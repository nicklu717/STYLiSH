//
//  PayResultViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PayResultViewController: UIViewController {
    
    var tab: UITabBarController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        tab = tabBarController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tab?.tabBar.isHidden = false
    }
}
