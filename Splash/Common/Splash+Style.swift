//
//  Splash+Style.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit

extension Splash {
    enum Style {
        enum color {
            static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
            static let yellow = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        }
    }
}

extension Splash.Style {
    enum Layer {
        static let imageCornersRadius: CGFloat = 8.0
    }
    
    enum Icon {
        
        private static var symbolConfigurationMedium: UIImage.SymbolConfiguration {
            return UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        }
        
        private static var symbolConfigurationSmall: UIImage.SymbolConfiguration {
            return UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .small)
        }
        
        static var arrowUpRight: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "arrow.up.right", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "arrow.up.right")
        }
        
        static var bookmark: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "bookmark", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "bookmark")
        }
    }
}
