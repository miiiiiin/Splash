//
//  UserServiceType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

protocol UserServiceType {
    func getMe() -> Observable<Result<User, Splash.Error>>
}
