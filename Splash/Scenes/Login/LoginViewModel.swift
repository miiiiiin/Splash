//
//  LoginViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/09.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

enum LoginState {
    case idle
    case fetchingToken
    case tokenIsFetched
}

protocol LoginViewModelInput {
    var loginAction: CocoaAction { get }
    var closeAction: CocoaAction { get }
}

protocol LoginViewModelOutput {
    var buttonName: Observable<String> { get }
    var loginState: Observable<LoginState> { get }
    var randomPhotos: Observable<[Photo]> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

final class LoginViewMode: NSObject, LoginViewModelInput, LoginViewModelOutput, LoginViewModelType {
    
    //MARK: Inputs&Outputs
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOutput { return self }
    
    //MARK: Input
    lazy var loginAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
//            self.auteh
        }
    }()
    
    lazy var closeAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
//            self.accessibilityScroll(<#T##direction: UIAccessibilityScrollDirection##UIAccessibilityScrollDirection#>)
        }
    }()
    
    
    //MARK: OUTPUT
    let buttonName: Observable<String>
    let loginState: Observable<LoginState>
    let randomPhotos: Observable<[Photo]>
    
    fileprivate let authManager: unsplashAuthManager
    private let userService: UserServiceType
    private let photoService: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var _authSession: Any?
}


//    lazy var closeAction: CocoaAction = {
//        return CocoaAction { [unowned self] _ in
//            self.sceneCoordinator.pop(animated: true)
//        }
//    }()






//
//    // MARK: Output
//    let buttonName: Observable<String>
//    let loginState: Observable<LoginState>
//    let randomPhotos: Observable<[Photo]>
//
//    // MARK: Private
//    fileprivate let authManager: UnsplashAuthManager
//    private let userService: UserServiceType
//    private let photoService: PhotoServiceType
//    private let sceneCoordinator: SceneCoordinatorType
//    private var _authSession: Any?
//
