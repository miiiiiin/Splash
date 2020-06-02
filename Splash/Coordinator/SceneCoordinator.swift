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

class SceneCoordinator: SceneCoordinatorType {
    
    static var shared: SceneCoordinator!
    
    fileprivate var window: UIWindow
    fileprivate var currentVC: UIViewController {
        didSet {
            currentVC.navigationController.delegate = self
            currentVC.tabBarController.delegate = self
        }
    }
    
    required init(window: UIWindow) {
        currentVC = window.rootViewController
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
     
        var controller = viewController
        if let tabBarController = controller as? UITabBarController {
            guard let selectedViewContrller = tabBarController.selectedViewContrller else {
                return tabBarController
            }
        }
        
        if let navigationController = viewController as? UINavigationController {
            controller = navigationController.viewControllers.first
            return actualViewController(for: controller)
        }
        return controller
    }
}

extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didshow viewController: UIViewController, animated: Bool) {
        currentVC = SceneCoordinator.actualViewController(for: viewController)
    }
}

extension SceneCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentVC = SceneCoordinator.actualViewController(for: viewController)
    }
}
