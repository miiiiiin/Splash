//
//  LoadingView.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        activityIndicatorView
            .add(to: self)
            .size(CGSize(width: 30, height: 30))
            .center()
        
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        isHidden = true
    }
}
