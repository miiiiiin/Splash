//
//  Extensions+String.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

extension String {
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
