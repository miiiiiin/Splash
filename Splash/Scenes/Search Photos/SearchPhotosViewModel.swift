//
//  SearchPhotosViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa

enum SearchType {
    case collectionPhotos(title: String, collectionID: Int, collectionService: CollectionServiceType)
    case searchPhotos(searchQuery: String, searchService: SearchServiceType)
}

protocol SearchPhotosViewModelInput {
    var loadMore: BehaviorSubject<Bool> { get }
    var photoDetailsAction: Action<Photo, Void> { get }
}

protocol SearchPhotosViewModelOutput {
    var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> { get }
    var navTitle: Observable<String> { get }
}

protocol SearchPhotosViewModelType {
    var inputs: SearchPhotosViewModelInput { get }
    var outputs: SearchPhotosViewModelOutput { get }
}

final class SearchPhotosViewModel: SearchPhotosViewModelInput, SearchPhotosViewModelOutput, SearchPhotosViewModelType {
    
    //MARK: Input&Output
    var inputs: SearchPhotosViewModelInput { return self }
    var outputs: SearchPhotosViewModelOutput { return self }
    
    private var photos: Observable<[Photo]>!
    private let cache: Cache
    private let sceneCoordinator: SceneCoordinatorType
    
    //MARK: Input
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    lazy var photoDetailsAction: Action<Photo, Void> = {
        return Action<Photo, Void> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            return self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
        }
    }()
    
    //MARK: Output
    var navTitle: Observable<String>
    
    lazy var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> = {
        return Observable.combineLatest(photos, cache.getAllObjects(ofType: Photo.self))
            .map { photos, cachedPhotos -> [Photo] in
                let cachedPhotos = cachedPhotos.filter {
                    photos.contains($0)
                }
                return zip(photos, cachedPhotos).map { photo, cachedPhoto -> Photo in
                var photo = photo
                photo.likes = cachedPhoto.likes
                photo.likedByUser = cachedPhoto.likedByUser
                return photo
            }
        }.mapMany { SearchPhotosCellModel(photo: $0)}
    }()
    
    //MARK: Init
    init(type: SearchType, cache: Cache = Cache.shared, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        
        self.cache = cache
        self.sceneCoordinator = sceneCoordinator
        
        var photoArray = [Photo]([])
        var currentPageNumber = 1
        var requestFirst: Observable<[Photo]>
        var requestNext: Observable<[Photo]>
        
        switch type {
        case let .collectionPhotos(title: title, collectionID: collectionID, collectionService: collectionService):
            requestFirst = collectionService.photos(fromCollectionId: collectionID, pageNumber: 1)
            
            requestNext = loadMore.asObservable()
                .flatMapLatest { loadMore -> Observable<[Photo]> in
                    guard loadMore else { return .empty() }
                    currentPageNumber += 1
                    return collectionService.photos(fromCollectionId: collectionID, pageNumber: currentPageNumber)
            }
            
            navTitle = Observable.just(title)
            
        case .searchPhotos(searchQuery: let searchQuery, searchService: let searchService):
            let searchResultsNumber = searchService
            .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
            .map { $0.total }
            .unwrap()
            
            requestFirst = searchService
            .searchPhotos(with: searchQuery, pageNumber: 1)
            .map { $0.results }
            .unwrap()
            
            requestNext = loadMore.asObservable()
                .flatMapLatest { loadMore -> Observable<[Photo]> in
                    guard loadMore else { return .empty() }
                    currentPageNumber += 1
                    return searchService
                    .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
                        .map { $0.results }
                    .unwrap()
            }
            
            navTitle = Observable.zip(Observable.just(searchQuery), searchResultsNumber)
                .map { query, resultNumber in
                    return "\(query): \(resultNumber) results"
            }
        }
        
        photos = requestFirst
        .merge(with: requestNext)
            .map { photos -> [Photo] in
                photos.forEach { photo in
                photoArray.append(photo)
            }
            return photoArray
        }
    }
}
