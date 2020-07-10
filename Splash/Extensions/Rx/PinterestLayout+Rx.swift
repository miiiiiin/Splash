//
//  PinterestLayout+Rx.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: PinterestLayout {
    func updateSize(_ indexPath: IndexPath) -> Binder<CGSize> {
        return Binder(base) { base, size in
//            self.delegate.sizes[indexPath] = size //fixme
            base.invalidateLayout()
        }
    }
}
