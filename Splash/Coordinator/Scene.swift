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
    case addToCollection
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
