//
//  UserService.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import TinyNetworking
import RxSwift

struct UserService: UserServiceType {
    
    private let splash: TinyNetworking<UnSplash>
    
    init(splash: TinyNetworking<UnSplash> = TinyNetworking<UnSplash>()) {
        self.splash = splash
    }
    
    func getMe() -> Observable<Result<User, Splash.Error>> {
        
    }
    
    
    
}
//
//private let unsplash: TinyNetworking<Unsplash>
//
//init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>()) {
//    self.unsplash = unsplash
//}
//
//func getMe() -> Observable<Result<User, Papr.Error>> {
//    return unsplash.rx
//        .request(resource: .getMe)
//        .map(to: User.self)
//        .map(Result.success)
//        .catchError { error in
//            let accessToken = UserDefaults.standard.string(forKey: Papr.Unsplash.clientID)
//            guard accessToken == nil else {
//                return .just(.failure(.other(message: error.localizedDescription)))
//            }
//            return .just(.failure(.noAccessToken))
//        }
//        .asObservable()
//}
