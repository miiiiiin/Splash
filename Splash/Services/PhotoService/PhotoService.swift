//
//  PhotoService.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/27.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct PhotoService: PhotoServiceType {
    
    private let cache: Cache
    private let unsplash: TinyNetworking<UnSplash>
    
    init(unsplash: TinyNetworking<UnSplash> = TinyNetworking<UnSplash>(), cache: Cache = Cache.shared) {
        self.cache = cache
        self.unsplash = unsplash
    }
    
    func like(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        return
    }
    
    func unlike(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        return
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        return
    }
    
    func photos(byPageNumber pgNumber: Int?, orderBy: OrderBy?) -> Observable<Result<[Photo], Splash.Error>> {
        return
    }
    
    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
        return
    }
    
    func photoDownloadLink(wihId id: String) -> Observable<Result<String, Splash.Error>> {
        return
    }
    
    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]> {
        return
    }
}
