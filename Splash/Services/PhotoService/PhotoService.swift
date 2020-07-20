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
        return splash.rx.request(resource: .likePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .map { $0.photo }
        .asObservable()
        .unwrap()
            .execute { self.cache.set(value: $0) }
            .map(Result.success)
            .catchError { _ in
                let accessToken = UserDefaults.standard.string(forKey: Constants.Splash.clientID)
                guard accessToken == nil else {
                    return .just(.failure(.other(message: "Failed to like")))
                }
                return .just(.failure(.noAccessToken))
        }
    }
    
    func unlike(photo: Photo) -> Observable<Result<Photo, Splash.Error>> {
        return splash.rx.request(resource: .unlikePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .map { $0.photo }
        .asObservable()
        .unwrap()
            .execute { self.cache.set(value: $0) } //update cache
            .map(Result.success)
            .catchError { _ in
                let accessToken = UserDefaults.standard.string(forKey: Constants.Splash.clientID)
                guard accessToken == nil else {
                    return .just(.failure(.other(message: "Failed to unlike")))
                }
                return .just(.failure(.noAccessToken))
        }
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        return splash.rx.request(resource: .photo(id: id, width: nil, height: nil, rect: nil))
            .map(to: Photo.self)
            .asObservable()
    }
    
    func photos(byPageNumber pgNumber: Int?, orderBy: OrderBy?) -> Observable<Result<[Photo], Splash.Error>> {
        let photos: UnSplash = .photos(page: pgNumber, perPage: nil, orderBy: orderBy)
        
        return splash.rx.request(resource: photos)
            .map(to: [Photo].self)
            .asObservable()
            .execute { self.cache.set(values: $0) } //populate the cache
            .map(Result.success)
            .catchError { .just(.failure(.other(message: $0.localizedDescription)))
            }
    }
    
    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
        return splash.rx.request(resource: .getMe)
            .map(to: PhotoStatistics.self)
    }
    
    func photoDownloadLink(wihId id: String) -> Observable<Result<String, Splash.Error>> {
        return splash.rx.request(resource: .photoDownloadLink(id: id))
            .map(to: Link.self)
            .map { $0.url }
        .asObservable()
        .unwrap()
            .map(Result.success)
            .catchError { _ in
                return .just(.failure(.other(message: "Failed to download photo")))
        }
    }
    
    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]> {
        return splash.rx.request(resource: .randomPhoto(collections: collections, isFeatured: isFeatured, username: nil, query: nil, width: nil, height: nil, orientation: orientation, count: 30))
            .map(to: [Photo].self)
            .asObservable()
    }
}
