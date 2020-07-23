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
    
    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotoResults> {
        return splash.rx.request(resource: .searchPhotos(query: query, page:
            pageNumber))
            .map(to: PhotoResults.self)
        .asObservable()
            .execute { self.cache.set(values: $0.results ?? []) }
    }
    
    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionResults> {
        return splash.rx.request(resource: .searchCollections(query: query, page: pageNumber, perPage: 10)
        )
        .map(to: PhotoCollectionResults.self)
        .asObservable()
    }
}
