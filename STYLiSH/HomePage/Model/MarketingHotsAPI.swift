//
//  STYLiSH API.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

class MarketingHotsAPI {
    enum Endpoint: String {
        case marketingHots = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
}

struct MarketingHots: Codable {
    let data: [Hots]
    let error: String?
}
