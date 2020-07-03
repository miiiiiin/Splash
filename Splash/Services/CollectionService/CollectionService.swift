//
//  CollectionService.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/03.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct CollectionService: CollectionServiceType {
    
    private let splash: TinyNetworking<UnSplash>
    private let cache: Cache
    
    init(splash: TinyNetworking<UnSplash> = TinyNetworking<UnSplash>(), cache: Cache = .shared) {
        self.splash = splash
        self.cache = cache
    }
    
    func collection(withID id: Int) -> Observable<PhotoCollection> {
        return splash.rx.request(resource: .collection(id: id))
            .map(to: PhotoCollection.self)
            .asObservable()
    }
    
    func collection(withUserName username: String) -> Observable<Result<[PhotoCollection], Splash.Error>> {
        return self.splash.rx.request(resource: .userCollections(username: username, page: 1, perPage: 20))
            .map(to: [PhotoCollection].self)
            .asObservable()
            .map(Result.success)
            .catchError {
            .just(.failure(.other(message: $0.localizedDescription)))
        }
    }
    
    func collection(byPageNumber page: Int) -> Observable<Result<[PhotoCollection], Splash.Error>> {
        //fixme
    }
    
    func photos(fromCollectionId id: Int, pageNumber: Int) -> Observable<[Photo]> {
        //fixme
    }
    
    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Splash.Error>> {
        //fixme
    }
    
    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Splash.Error>> {
        //fixme
    }
    
    func createCollection(with title: String, description: String, isPrivate: Bool) -> Observable<Result<PhotoCollection, Splash.Error>> {
        //fixme
    }
}
