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
import AuthenticationServices

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

final class LoginViewModel: NSObject, LoginViewModelInput, LoginViewModelOutput, LoginViewModelType {
    
    //MARK: Inputs&Outputs
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOutput { return self }
    
    //MARK: Input
    lazy var loginAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.authenticate()
        }
    }()
    
    lazy var closeAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()
    
    
    //MARK: OUTPUT
    let buttonName: Observable<String>
    let loginState: Observable<LoginState>
    let randomPhotos: Observable<[Photo]>
    
    fileprivate let authManager: SplashAuthManager
    private let userService: UserServiceType
    private let photoService: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var _authSession: Any?
    
    private var authSession: ASWebAuthenticationSession? {
        get {
            return _authSession as? ASWebAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }
    
    private let buttonNameProperty = BehaviorSubject<String>(value: "Login with Splash")
    private let loginStateProperty = BehaviorSubject<LoginState>(value: .idle)
    
    //MARK: Init
    init(userService: UserServiceType = UserService(), photoService: PhotoServiceType = PhotoService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, authManager: SplashAuthManager = SplashAuthManager.shared) {
       
        self.userService = userService
        self.photoService = photoService
        self.sceneCoordinator = sceneCoordinator
        self.authManager = authManager
        
        loginState = loginStateProperty.asObservable()
        buttonName = buttonNameProperty.asObservable()
        
        randomPhotos = photoService.randomPhotos(from: ["446755"], isFeatured: true, orientation: .portrait)
        
        super.init()
        self.authManager.delegate = self
    }
    
    private lazy var navigateToTabBarAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            return self.sceneCoordinator.transition(to: Scene.splash)
        }
    }()
    
    private lazy var alertAction: Action<Splash.Error, Void> = {
        Action<Splash.Error, Void> { [unowned self] error in
            let alertViewModel = AlertViewModel(title: "Upsss..", message: error.errorDescription, mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
            
        }
    }()
    
    private func authenticate() -> Observable<Void> {
        self.authSession = ASWebAuthenticationSession(url: authManager.authURL, callbackURLScheme: Constants.Splash.callbackURLScheme, completionHandler: { [weak self] (callbackUrl, error) in
            guard let callbackUrl = callbackUrl else { return }
            self?.authManager.receivedCodeRedirect(url: callbackUrl)
        })
        
        if #available(iOS 13.0, *) {
            self.authSession?.presentationContextProvider = self //fixme
        }
        self.authSession?.start()
        return .empty()
    }
}

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

extension LoginViewModel: SplashSessionListener {
    func didReceiveRedirect(code: String) {
        loginStateProperty.onNext(.tokenIsFetched)
        buttonNameProperty.onNext("Please wait...")
        self.authManager.accessToken(with: code) { [unowned self] result in
            switch result {
            case .success:
                self.navigateToTabBarAction.execute(())
            case let .failure(error):
                self.alertAction.execute(error)
            }
        }
    }
}
