//
//  Scene.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

/**
    Refers to a screen managed by a view controller.
    It can be a regular screen, or a modal dialog.
    It comprises a view controller and a view model.
*/

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case splash
    case login
    case alert
    case activity([Any])
    case photoDetails
    case addToCollection(AddToCollectionViewModel)
    case createCollection
    case searchPhotos
    case searchCollections
    case searchUsers
    case userProfile
    
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .splash:
            let tabBarController = SplashTapBarController()
            
            //MARK: - Home View Controller -
            var homeVC = HomeViewController()
            let homeViewModel = HomeViewModel()
            let rootVC = UINavigationController(rootViewController: homeVC)
//            homeVC.bind(homeViewModel)
            
            break
        case .login:
            break
        case .alert:
            break
        case .activity(_):
            break
        case .photoDetails:
            break
        case .addToCollection:
//            var vc = AddToCollectionViewController.initFromNib()
//            let rootViewController = UINavigationController(rootViewController: vc)
//            vc.bind(to: viewModel)
//            return .present(rootViewController)//FIXME
            break
            
        case .createCollection:
            break
        case .searchPhotos:
            break
        case .searchCollections:
            break
        case .searchUsers:
            break
        case .userProfile:
            break
        }
    }
}
