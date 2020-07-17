//
//  Extensions+UIView.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/11.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

extension UIView {

    func dim(withAlpha alpha: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let coverLayer = CALayer()
            coverLayer.frame = self.bounds
            coverLayer.backgroundColor = UIColor.black.cgColor
            coverLayer.opacity = Float(alpha)
            self.layer.addSublayer(coverLayer)
        }
    }
    
    func roundCorners(_ corners: UIRectCorner = .allCorners, withRadius radius: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
