//
//  AppDelegate.swift
//  Splash
//
//  Created by Running Raccoon on 2020/04/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = UINavigationController()
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        SceneCoordinator.shared = sceneCoordinator
        sceneCoordinator.transition(to: Scene.splash)
        return true
    }
}

