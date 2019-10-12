//
//  ResponseObject.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    let id: Int
    let category: String
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [Color]
    let sizes: [String]
    let variants: [Variant]
    let mainImage: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
}

struct Color: Codable {
    
    let code: String
    let name: String
}

struct Variant: Codable {
    
    let colorCode: String
    let size: String
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code", size, stock
    }
}

struct Campaign: Codable {
    
    let productID: Int
    let picture: String
    let story: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id", picture, story
    }
}

struct Hots: Codable {
    
    let title: String
    let products: [Product]
}

struct User: Codable {
    
    let id: Int
    let provider: String
    let name: String
    let email: String
    let picture: String
}

struct RequestError: Codable {
    let error: String
}
