//
//  SplashError.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

extension Splash {
    enum Error: LocalizedError {
        case noAccessToken
        case other(message: String)
        
        var errorDescription: String {
            switch self {
            case .noAccessToken:
                return "Please provide the access token."
            case let .other(message: message):
                return message
            }
        }
    }
}
