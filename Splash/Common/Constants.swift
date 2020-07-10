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
        static let clientID = ClientAuth.clientId
        static let clientSecret = ClientAuth.secret
        static let redirectURL = "splash://unsplash"
        static let callbackURLScheme = "splash://"
    }
}

extension Constants.Splash {
    enum ClientAuth {
        static let clientId = ClientAuth.environmentVariable(named: "0xEY4jia4h4ZY9VHWheBUzwbZxO9TWVYWha3Q-_q2ZE") ?? ""
        static let secret = ClientAuth.environmentVariable(named: "_gL7FKhuBMHgtd2PmBjgTcvgGU1W3nz34Zzh0GoHA68") ?? ""
        
        
        private static func environmentVariable(named: String) -> String? {
            guard let infoDict = Bundle.main.infoDictionary, let value = infoDict[named] as? String else {
                debugPrint("Missing Environment Variable: '\(named)'")
                return nil
            }
            return value
        }
    }
}
