//
//  Hero+Rx.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/06.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import Hero
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    //Bindable sink for 'hero.id'
    var heroId: Binder<String> {
        return Binder(base) { view, id in
            view.hero.id = id
        }
    }
}
