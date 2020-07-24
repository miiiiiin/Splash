//
//  BouncyView.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/23.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

class BouncyView: UIView {
    
    private let emojiLbl = UILabel()
    private let messageLbl = UILabel()
    private let shadow = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojiLbl.textAlignment = .center
        emojiLbl.backgroundColor = .clear
        emojiLbl.font = .systemFont(ofSize: 60)
        emojiLbl.translatesAutoresizingMaskIntoConstraints = false
       
        addSubview(emojiLbl)
        
        emojiLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emojiLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -35.0).isActive = true
        
        shadow.fillColor = UIColor(white: 0, alpha: 0.05).cgColor
        layer.addSublayer(shadow)
        
        messageLbl.textAlignment = .center
        messageLbl.backgroundColor = .clear
        messageLbl.font = UIFont.preferredFont(forTextStyle: .body)
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageLbl)
        
        messageLbl.centerXAnchor.constraint(equalTo: emojiLbl.centerXAnchor).isActive = true
        messageLbl.topAnchor.constraint(equalTo: emojiLbl.bottomAnchor, constant: 35.0).isActive = true
        
        resetAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = 30
        let height: CGFloat = 12
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        shadow.path = UIBezierPath(ovalIn: rect).cgPath
        
        let bounds = self.bounds
        shadow.bounds = rect
        shadow.position = CGPoint(x: bounds.width/2, y: bounds.height/2 + 15)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        resetAnimations()
    }
    
    func configure(emoji: String, message: String) {
        emojiLbl.text = emoji
        messageLbl.text = message
    }
    
    @objc private func resetAnimations() {
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let duration: TimeInterval = 1
        
        let emojiBounce = CABasicAnimation(keyPath: "transform.translation.y")
        emojiBounce.toValue = -10
        emojiBounce.repeatCount = .greatestFiniteMagnitude
        emojiBounce.autoreverses = true
        emojiBounce.duration = duration
        emojiBounce.timingFunction = timingFunction
        
        emojiLbl.layer.add(emojiBounce, forKey: "noresultcell.emoji")
        
        let shadowScale = CABasicAnimation(keyPath: "transform.scale")
        shadowScale.toValue = 0.9
        shadowScale.repeatCount = .greatestFiniteMagnitude
        shadowScale.autoreverses = true
        shadowScale.duration = duration
        shadowScale.timingFunction = timingFunction
        
        shadow.add(shadowScale, forKey: "noresultcell.shadow")
    }
}
