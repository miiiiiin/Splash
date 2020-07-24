//
//  Extensions+String.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
    
    func nsRange(of searchString: String) -> NSRange? {
        let nsString = self as NSString
        let range = nsString.range(of: searchString)
        return range.location != NSNotFound ? range : nil
    }
    
    func attributedString(withHighlightedText text: String, color: UIColor = Splash.Style.color.yellow) -> NSAttributedString {
        guard let range = lowercased().nsRange(of: text.lowercased()) else {
            return NSAttributedString(string: self)
        }

        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)

        return attributedString
    }
}
