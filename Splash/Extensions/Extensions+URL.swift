//
//  Extensions+URL.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/09.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

extension URL {
    func value(for querykey: String) -> String? {
        guard let items = URLComponents(string: absoluteString)?.queryItems else {
            return nil
        }
        for item in items where item.name == querykey {
            return item.value
        }
        return nil
    }
    
    func appendingQueryParameters(_ parameters: [String : String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = urlComponents.queryItems ?? []
        
        queryItems += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}
