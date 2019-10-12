//
//  SignInAPI.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

class SignInAPI {
    enum Endpoint: String {
        case signIn = "https://api.appworks-school.tw/api/1.0/user/signin"
    }
}

struct SignInInfo: Codable {
    let provider: String
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case provider
        case accessToken = "access_token"
    }
}

struct SignInResponse: Codable {
    let data: SignInResponseContent
}

struct SignInResponseContent: Codable {
    let accessToken: String
    let accessExpired: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessExpired = "access_expired"
        case user
    }
}
