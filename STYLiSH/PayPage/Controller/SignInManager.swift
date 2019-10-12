//
//  SignInManager.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import SCLAlertView
import KeychainAccess

protocol SignInManagerDelegate: class {
    
    var userToken: String? { get set }
}

class SignInManager {
    
    static let sharedInstance = SignInManager()
    
    weak var delegate: SignInManagerDelegate?
    
    private let alert = SCLAlertView()
    
    func postSignInInfo(with signInInfo: SignInInfo) {
        
        guard
            let signInURL = URL(string: SignInAPI.Endpoint.signIn.rawValue)
        else {
            print("Sign In URL Converting Failure")
            return
        }
        
        var request = URLRequest(url: signInURL)
        request.method = .post
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        do {
            request.httpBody = try JSONEncoder().encode(signInInfo)
        } catch let error {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                
                print(error)
                
                DispatchQueue.main.async {
                    self.alert.showWarning(NSLocalizedString("Fail", comment: ""), subTitle: NSLocalizedString("LoginFailure", comment: ""))
                }
            }
            
            if let data = data {

                DispatchQueue.main.async {
                    self.alert.showSuccess(NSLocalizedString("Success", comment: ""), subTitle: NSLocalizedString("LoginSuccess", comment: ""))
                }
                
                let decoder = JSONDecoder()
                do {
                    let signInResponse = try decoder.decode(SignInResponse.self, from: data)
                    
                    let keychain = Keychain(service: "com.wein7.STYLiSH")
                    keychain["User Token"] = signInResponse.data.accessToken
                    self.delegate?.userToken = signInResponse.data.accessToken
                    
                } catch let error {
                    print("解析錯誤：\(error)")
                }
            }
        }

        task.resume()
    }
}
