//
//  UIAlertController+RX.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/06.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIAlertController {
    //bindable sink for 'title'
    var title: Binder<String> {
        return Binder(base) { alertController, title in
            alertController.title = title
        }
    }

    //bindalbe sink for 'message'
    var message: Binder<String> {
        return Binder(base) { alertController, message in
            alertController.message = message
        }
    }
}
