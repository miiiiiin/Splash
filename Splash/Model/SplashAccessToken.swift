//
//  SplashAccessToken.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/09.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct SplashAccessToken: Decodable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
    }
}
