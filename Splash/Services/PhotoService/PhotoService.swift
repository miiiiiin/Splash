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
    private let splash: TinyNetworking<UnSplash>
    
    init(splash: TinyNetworking<UnSplash> = TinyNetworking<UnSplash>(), cache: Cache = Cache.shared) {
        self.cache = cache
        self.splash = splash
    }
    
    func like(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        
    }
    
    func unlike(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        
    }
    
    func photos(byPageNumber pgNumber: Int?, orderBy: OrderBy?) -> Observable<Result<[Photo], Splash.Error>> {
        
    }
    
    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
        
    }
    
    func photoDownloadLink(wihId id: String) -> Observable<Result<String, Splash.Error>> {
        
    }
    
    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]> {
        
    }
}
