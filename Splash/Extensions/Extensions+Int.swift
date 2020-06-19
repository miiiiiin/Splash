//
//  Extensions+Int.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

extension Int {
    var abbreviatd: String {
        // less than 1000, no abbreviation
        if self < 1000 {
            return "\(self)"
        }
        
        // less than 1 million, abbreviate to thousands
        if self < 1000000 {
            var n = Double(self)
            n = Double(floor(n/100)/10)
            return "\(n.description)K"
        }
        
        // more than 1 million, abbreviate to millions
        var n = Double(self)
        n = Double(floor(n/100000)/10)
        return "\(n.description)M"
    }
}
