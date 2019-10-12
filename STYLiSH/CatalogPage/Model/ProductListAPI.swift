//
//  ProductListAPI.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

class ProductListAPI {
    
    enum EndPoint: String {
        
        case women = "/api/1.0/products/women"
        case men = "/api/1.0/products/men"
        case accessories = "/api/1.0/products/accessories"
        
        var urlComponent: URLComponents {
            
            var urlComponent = URLComponents()
            
            urlComponent.scheme = "https"
            urlComponent.host = "api.appworks-school.tw"
            urlComponent.path = self.rawValue
            
            return urlComponent
        }
    }
}

struct ProductList: Codable {
    var data: [Product]
    var paging: Int?
}
