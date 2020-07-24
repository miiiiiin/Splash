//
//  UserCellModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit
import RxSwift

protocol UserCellModelInput {}

protocol UserCellModelOutput {
    var fullName: Observable<NSAttributedString> { get }
    var profilePhotoURL: Observable<URL> { get }
}

protocol UserCellModelType {
    var inputs: UserCellModelInput { get }
    var outputs: UserCellModelOutput { get }
}

final class UserCellModel: UserCellModelInput, UserCellModelOutput, UserCellModelType {
    
    
    //MARK: Input&Output
    var inputs: UserCellModelInput { return self }
    var outputs: UserCellModelOutput { return self }
    
    //MARK: Output
    let fullName: Observable<NSAttributedString>
    let profilePhotoURL: Observable<URL>
    
    init(user: User, searchQuery: String) {
        let userStream = Observable.just(user)
        
        fullName = userStream
            .map { $0.fullName?.attributedString(withHighlightedText: searchQuery)}
            .unwrap()
        
        profilePhotoURL = userStream
            .map { $0.profileImage?.medium }
            .unwrap()
            .mapToURL()
    }
}
