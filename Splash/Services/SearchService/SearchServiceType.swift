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
    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotoResult>
    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionResult>
    func searchUsers(with query: String, pageNumber: Int) -> Observable<UserResult>
}
