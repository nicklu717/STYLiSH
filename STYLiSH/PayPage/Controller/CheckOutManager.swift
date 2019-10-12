//
//  CheckOutManager.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol CheckOutManagerDelegate: class {
    
    var checkOutPrime: String? { get set }
    
    func checkOutDidSuccess()
}

class CheckOutManager {
    
    weak var delegate: CheckOutManagerDelegate?
    
    func postCheckOutInfo(with checkOutInfo: CheckOutInfo, userToken: String) {
        
        guard
            let checkOutURL = URL(string: CheckOutAPI.Endpoint.signIn.rawValue)
        else {
            print("Check Out URL Converting Failure")
            return
        }
        
        var request = URLRequest(url: checkOutURL)
        request.method = .post
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(userToken)"]
        
        do {
            request.httpBody = try JSONEncoder().encode(checkOutInfo)
        } catch let error {
            print("Check Out Info Encoding Failure.\n\(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            guard
                let response = response as? HTTPURLResponse
            else {
                return
            }
            
            switch response.statusCode / 100 {
                
            case 2:
                print("Check Out Success")
                self.delegate?.checkOutDidSuccess()
                
            case 4:
                print("Check Out Failure")
                
            default: return
            }
        }
        
        task.resume()
    }
}
