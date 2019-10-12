//
//  FacebookLoginViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/29.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import KeychainAccess

class FacebookLoginViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginWithFacebook() {
        
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let result = result {
                
                guard
                    let facebookTokenString = result.token?.tokenString
                else {
                    print("Couldn't Get Facebook Token")
                    return
                }
                
                let signInInfo = SignInInfo(provider: "facebook", accessToken: facebookTokenString)
                
                if result.isCancelled {
                
                    print("Facebook 登入失敗")
                
                } else {
                    
                    SignInManager.sharedInstance.postSignInInfo(with: signInInfo)
                    
                    DispatchQueue.main.async {
                        self.dismiss()
                    }
                }
                
            } else {
                print("\(String(describing: error))")
            }
        }
    }
}
