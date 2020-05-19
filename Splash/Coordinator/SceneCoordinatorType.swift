//
//  SceneCoordinatorType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    func transition(to scene: TargetScene) -> Observable<Void>
    func pop(animated: Bool) -> Observable<Void>
}
