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
    case alert(AlertViewModel)
    case activity([Any])
    case photoDetails(PhotoDetailsViewModel)
    case addToCollection(AddToCollectionViewModel)
    case createCollection(CreateCollectionViewModel)
    case searchPhotos(SearchPhotosViewModel)
//    case searchCollections
//    case searchUsers
    case userProfile(UserProfileViewModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .splash:
            let tabBarController = SplashTapBarController()
            //MARK: - Home View Controller -
            var homeVC = HomeViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 1))
            let homeViewModel = HomeViewModel()
            let rootHomeVC = SplashNavigationController(rootViewController: homeVC)
            homeVC.bind(to: homeViewModel)
            
            //MARK: - SearchViewController -
            var searchVC = SearchViewController.initFromNib()
            let searchViewModel = SearchViewModel()
            let rootSearchVC = SplashNavigationController(rootViewController: searchVC)
            searchVC.bind(to: searchViewModel)
            
            //MARK: - CollectionsViewController -
            var collectionVC = CollectionsViewController()
            let collectionViewModel = CollectionsViewModel()
            let rootCollectionVC = SplashNavigationController(rootViewController: collectionVC)
            collectionVC.bind(to: collectionViewModel)
            
            let photosTapBarItem = UITabBarItem (
                title: "Photos",
                image: Splash.Style.Icon.arrowUpRight,
                tag: 0
            )
            
            let collectionsTabBarItem = UITabBarItem (
                title: "collectionsTabBarItem",
                image: Splash.Style.Icon.arrowUpRight,
                tag: 1
            )
            
            let searchTabBarItem = UITabBarItem (
                title: "Search",
                image: Splash.Style.Icon.arrowUpRight,
                tag: 2
            )
            
            collectionsTabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            photosTapBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            searchTabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            
            rootHomeVC.tabBarItem = photosTapBarItem
            rootCollectionVC.tabBarItem = collectionsTabBarItem
            rootSearchVC.tabBarItem = searchTabBarItem
            tabBarController.viewControllers = [
                rootHomeVC,
                rootCollectionVC,
                rootSearchVC
            ]
                
            return .tabBar(tabBarController)

        case .login:
            //fixme
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)
            
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return.alert(vc)
            
        case .activity(_):
            //fixme
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)
        case .photoDetails:
            //fixme
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)
            
        case .addToCollection:
//            var vc = AddToCollectionViewController.initFromNib()
//            let rootViewController = UINavigationController(rootViewController: vc)
//            vc.bind(to: viewModel)
//            return .present(rootViewController)//FIXME
            
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)//fixme
        case .createCollection:
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)//fixme
        case let .searchPhotos(viewModel):
//            var vc = SearchPhotosViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 2))
//            vc.bind(to: viewModel)
            
//            return .push(vc)
            
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)//fixme
            
//        case .searchCollections:
//            break
//        case .searchUsers:
//            break
        case .userProfile:
            let tabBarController = SplashTapBarController()
            return .tabBar(tabBarController)//fixme
        }
    }
}
