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
    
    init(cache: Cache = Cache.shared) {
        
    }
    
    func like(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        <#code#>
    }
    
    func unlike(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        <#code#>
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        <#code#>
    }
    
    func photos(byPageNumber pgNumber: Int?, orderBy: OrderBy?) -> Observable<Result<[Photo], Splash.Error>> {
        <#code#>
    }
    
    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
        <#code#>
    }
    
    func photoDownloadLink(wihId id: String) -> Observable<Result<String, Splash.Error>> {
        <#code#>
    }
    
    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]> {
        <#code#>
    }
}
