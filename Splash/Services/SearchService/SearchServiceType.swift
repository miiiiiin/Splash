//
//  SearchServiceType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/23.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchServiceType {
    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotoResults>
    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionResults>
//    func searchUsers(with query: String, pageNumber: Int) -> Observable<UserResult>
//fixme
}
