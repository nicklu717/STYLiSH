//
//  CheckOutAPI.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

class CheckOutAPI {
    enum Endpoint: String {
        case signIn = "https://api.appworks-school.tw/api/1.0/order/checkout"
    }
}

struct CheckOutInfo: Codable {
    var prime: String
    let order: Order
}

struct Order: Codable {
    let shipping: String = "delivery"
    let payment: String = "credit_card"
    let subtotal: Int
    let freight: Int
    let total: Int
    let recipient: Recipient
    let list: [OrderedProduct]
}

struct Recipient: Codable {
    let name: String
    let phone: String
    let email: String
    let address: String
    let time: String
}

struct OrderedProduct: Codable {
    let id: String
    let name: String
    let price: Int16
    let color: Color
    let size: String
    let qty: Int16
}
