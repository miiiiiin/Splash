//
//  UIScrollView+Rx.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/15.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {
    
    func reachedBottom(offset: CGFloat = 500.0) -> ControlEvent<Bool> {
        /**
        Shows if the bottom of the UIScrollView is reached.
        - parameter offset: A threshhold indicating the bottom of the UIScrollView.
        - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
        */
        
        let source = contentOffset.map { contentOffset -> Bool in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            
            let y = contentOffset.y + self.base.contentInset.top + self.base.contentInset.bottom
            let threshold = max(offset, self.base.contentSize.height - visibleHeight - offset)
            return y >= threshold
        }
        .distinctUntilChanged()
        return ControlEvent(events: source)
    }
}
