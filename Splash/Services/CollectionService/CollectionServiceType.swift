//
//  CollectionServiceType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/03.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

protocol CollectionServiceType {
    func collection(withID id: Int) -> Observable<PhotoCollection>
    
    func collections(withUserName username: String) -> Observable<Result<[PhotoCollection], Splash.Error>>
    
//    func collection(byPageNumber page: Int) -> Observable<Result<[PhotoCollection], Splash.Error>>
//
    func photos(fromCollectionId id: Int, pageNumber: Int) -> Observable<[Photo]>
//
    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Splash.Error>>
//
//    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Splash.Error>>
//
//    func createCollection(with title: String, description: String, isPrivate: Bool) -> Observable<Result<PhotoCollection, Splash.Error>>
}
