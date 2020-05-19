//
//  SceneTransitionType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

enum SceneTransitionType {
    case root(UIViewController)
    case push(UIViewController)
    case present(UIViewController)
    case alert(UIViewController)
    case tabBar(UIViewController)
}

