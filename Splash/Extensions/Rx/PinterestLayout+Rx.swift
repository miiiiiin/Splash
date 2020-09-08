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
    
    private var delegate: RxPinterestLayoutDelegateProxy {
        print("base check: \(base)")
        return RxPinterestLayoutDelegateProxy.proxy(for: base)
    }
    
    func updateSize(_ indexPath: IndexPath) -> Binder<CGSize> {
        return Binder(base) { base, size in
            print("base check2222: \(base)")
            self.delegate.sizes[indexPath] = size //fixme
            base.invalidateLayout()
        }
    }
}
