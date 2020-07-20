//
//  HomeViewCellHeaderModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/27.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewCellHeaderModelInput {}

protocol HomeViewCellHeaderModelOutput {
    var profileImageURL: Observable<URL> { get }
    var fullName: Observable<String> { get }
    var userName: Observable<String> { get }
    var updatedTime: Observable<String> { get }
}

protocol HomeViewCellHeaderModelType {
    var inputs: HomeViewCellHeaderModelInput { get }
    var outputs: HomeViewCellHeaderModelOutput { get }
}

struct HomeViewCellHeaderModel: HomeViewCellHeaderModelInput, HomeViewCellHeaderModelOutput, HomeViewCellHeaderModelType {
    
    var inputs: HomeViewCellHeaderModelInput { return self }
    var outputs: HomeViewCellHeaderModelOutput { return self }
    
    let profileImageURL: Observable<URL>
    let fullName: Observable<String>
    let userName: Observable<String>
    let updatedTime: Observable<String>
    
    init(photo: Photo) {
        let photoStream = Observable.just(photo)
        
        profileImageURL = photoStream
            .map { $0.user?.profileImage?.large }
            .unwrap()
            .mapToURL()
        
        fullName = photoStream
            .map { $0.user?.fullName }
            .unwrap()
        
        userName = photoStream
            .map { $0.user?.username ?? "" }
//        .map { "@\($0.user?.username ?? "")" }//fixme
            .unwrap()
        
        updatedTime = photoStream
            .map { $0.updatedAt?.toDate?.abbreviated }
            .unwrap()
    }
}

