//
//  SearchService.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/23.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct SearchService: SearchServiceType {
    private let splash: TinyNetworking<UnSplash>
    private let cache: Cache
    
    init(splash: TinyNetworking<UnSplash> = TinyNetworking<UnSplash>(), cache: Cache = .shared) {
        self.splash = splash
        self.cache = cache
    }
    
    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotoResult> {
        return splash.rx.request(resource: .searchPhotos(query: query, page:
            pageNumber)
        )
        .map(to: PhotoResult.self)
        .asObservable()
        .execute { self.cache.set(values: $0.results ?? []) }
    }
    
    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionResult> {
        return splash.rx.request(resource: .searchCollections(query: query, page: pageNumber, perPage: 10)
        )
        .map(to: PhotoCollectionResult.self)
        .asObservable()
    }
    
    func searchUsers(with query: String, pageNumber: Int) -> Observable<UserResult> {
        return splash.rx.request(resource: .searchUsers(query: query, page: pageNumber, perPage: 10)
        )
        .map(to: UserResult.self)
        .asObservable()
    }
}
