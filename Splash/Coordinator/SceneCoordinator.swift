//
//  SceneCoordinator.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/02.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 Scene coordinator, manage scene navigation and presentation.
*/

class SceneCoordinator: NSObject, SceneCoordinatorType {
    
    static var shared: SceneCoordinator!
    
    fileprivate var window: UIWindow
    fileprivate var currentVC: UIViewController {
        didSet {
            currentVC.navigationController?.delegate = self
            currentVC.tabBarController?.delegate = self
        }
    }
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
     
        var controller = viewController
        if let tabBarController = controller as? UITabBarController {
            guard let selectedViewContrller = tabBarController.selectedViewController else {
                return tabBarController
            }
        }
        
        if let navigationController = viewController as? UINavigationController {
            controller = navigationController.viewControllers.first!
            return actualViewController(for: controller)
        }
        return controller
    }
    
    func transition(to scene: TargetScene) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        switch scene.transition {
        case let .tabBar(tabBarController):
            guard let selectedViewController = tabBarController.selectedViewController else {
                fatalError("selected view controller doesn't exist")
            }
            
            currentVC = SceneCoordinator.actualViewController(for: selectedViewController)
            window.rootViewController = tabBarController
        case let .root(viewController):
            currentVC = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
            
        case let .push(viewController):
            guard let navigationController = currentVC.navigationController else {
                fatalError("can't push a view contrller without a current navigation controller")
            }
            
          _ = navigationController.rx.delegate
                    .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
//                        .bind(to: subject)
//                    .ignoreElements()
            
            navigationController.pushViewController(SceneCoordinator.actualViewController(for: viewController), animated: true)
        case let .present(viewController):
            viewController.modalPresentationStyle = .fullScreen
            currentVC.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentVC = SceneCoordinator.actualViewController(for: viewController)
        case let .alert(viewController):
            currentVC.present(viewController, animated: true) {
                subject.onCompleted()
            }
        }
        
        return subject
        .asObservable()
        .take(1)
    }
    
    func pop(animated: Bool) -> Observable<Void> {
        var isDisposed = false
        var currentObserver: AnyObserver<Void>?
        let source = Observable<Void>.create { observer in
            currentObserver = observer
            return Disposables.create {
                isDisposed = true
            }
        }
        
        if let presentingViewController = currentVC.presentingViewController {
            currentVC.dismiss(animated: animated) {
                if !isDisposed {
                    self.currentVC = SceneCoordinator.actualViewController(for: presentingViewController)
                    currentObserver?.on(.completed)
                }
            }
        } else if let navigationController = currentVC.navigationController {
            _ = navigationController
                .rx
                .delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
//                .bind(to: currentObserver!)
            //                .ignoreElements()
            
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentVC)")
            }
            
            if !isDisposed {
                currentVC = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
            }
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentVC)")
        }
        
        return source
        .take(1)
//        .ignoreElements() //fixme
    }
}

//Cannot declare conformance to 'NSObjectProtocol' in Swift; 'SceneCoordinator' should inherit 'NSObject' instead
extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentVC = SceneCoordinator.actualViewController(for: viewController)
    }
}

extension SceneCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentVC = SceneCoordinator.actualViewController(for: viewController)
    }
}
