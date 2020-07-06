//
//  PhotoServiceType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/27.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoServiceType {
    func like(photo: Photo) -> Observable<Result<Photo, Splash.Error>>
    
    func unlike(photo: Photo) -> Observable<Result<Photo, Splash.Error>>
    
    func photo(withId id: String) -> Observable<Photo>
    
    func photos(byPageNumber pgNumber: Int?, orderBy: OrderBy?) -> Observable<Result<[Photo], Splash.Error>>
    
//    func statistics(of photo: Photo) -> Observable<PhotoStatistics>
    //fixme
    func photoDownloadLink(wihId id: String) -> Observable<Result<String, Splash.Error>>
    
    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]>
}

