//
//  SceneTransitionType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

enum SceneTransitionType {
    case root(UIViewController)// make view controller the root view controller.
    case push(UIViewController)// push view controller to navigation stack.
    case present(UIViewController)// present view controller.
    case alert(UIViewController)// present alert.
    case tabBar(UITabBarController)// make tab bar controller the root controller.
}
