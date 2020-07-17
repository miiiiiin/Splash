//
//  UIBarButtonItem+Rx.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/17.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    //Bindable sink for `image` property.
    public var image: Binder<UIImage> {
        return Binder(base) { button, image in
            print("button bind: \(button.image), \(image)")
            button.image = image
        }
    }
}
