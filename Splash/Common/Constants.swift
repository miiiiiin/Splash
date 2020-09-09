//
//  Constants.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

enum Constants {}

extension Constants {
    enum Splash {
        static let host = "unsplash.com"
        static let baseurl = "https://api.unsplash.com/"
        static let callbackURLScheme = "splash://"
        static let clientID = ClientAuth.clientId
        static let clientSecret = ClientAuth.secret
        static let redirectURL = "splash://unsplash"
//        static let authorizeURL = "https://unsplash.com/oauth/authorize"
//        static let tokenURL = "https://unsplash.com/oauth/token"
    }
}

extension Constants.Splash {
    enum ClientAuth {
        static let clientId = "uJO8NqgagYJtdwPgOjFDkKsNCvg8ymkako9SI990wC0"//ClientAuth.environmentVariable(named: "uJO8NqgagYJtdwPgOjFDkKsNCvg8ymkako9SI990wC0") ?? ""
        static let secret = "gCvMF9lqjAn7p5bs8YRVxRdZotaSQLKTEa9x"//ClientAuth.environmentVariable(named: "gCvMF9lqjAn7p5bs8YRVxRdZotaSQLKTEa9x-CzQVgA") ?? ""
        
        
        private static func environmentVariable(named: String) -> String? {
            guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                print("Missing Environment Variable: '\(named)'")
                return nil
            }
            return value
        }
        
//        private static func environmentVariable(named: String) -> String? {
//            guard let infoDict = Bundle.main.infoDictionary, let value = infoDict[named] as? String else {
//                debugPrint("Missing Environment Variable: '\(named)'")
//                return nil
//            }
//            return value
//        }
    }
}
