//
//  SplashAuthError.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/09.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct SplashAuthError: Decodable {
    let error: String
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
