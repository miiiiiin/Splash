//
//  HomeViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelInput {
    //Call when the pull-to-refresh is invoked
    var refreshProperty: BehaviorSubject<Bool> { get }
    
    //Call when the bottom of the list is reached
    var loadMoreProperty: BehaviorSubject<Bool> { get }
    
    //Call when an OrderBy value is invoked
    var orderByProperty: BehaviorSubject<OrderBy> { get }
}

protocol HomeViewModelOutput {
    //Emits a boolean when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool> { get }
    
    //Emits a boolean when the content is loading or not.
    var isLoadingMore: Observable<Bool> { get }
    
    //Emits an OrderBy value when an OsrderBy option is chosen
    var isOrderBy: Observable<OrderBy> { get }
    
    //Emits a boolean  when the first page is requested
    var isFirstPageRequested: Observable<Bool> { get }
    
    //Emites the child viewModels
    var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput{
  
    //MARK: - Inputs & Outputs -
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }
    
    //MARK: - Input -
    let refreshProperty = BehaviorSubject<Bool>(value: true)
    let loadMoreProperty = BehaviorSubject<Bool>(value: false)
    let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)
    
    //Mark: - Output -
    let isRefreshing: Observable<Bool>
    let isLoadingMore: Observable<Bool>
    let isOrderBy: Observable<OrderBy>
    let isFirstPageRequested: Observable<Bool>
    let homeViewCellModelTypes: Observable<[HomeViewCellModelType]>
      
    
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    
    init(cache: Cache = Cache.shared, service: PhotoServiceType = PhotoService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        
        self.cache = cache
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        
        var currPageNumber = 1
        var photoArray = [Photo]()
        
        let firstResult = Observable.combineLatest(refreshProperty, orderByProperty).flatMapLatest { isRefreshing, orderBy -> Observable<Result<[Photo], Splash.Error>> in
            guard isRefreshing else { return .empty() }
            return service.photos(byPageNumber: nil, orderBy: orderBy)
        }
        .execute { _ in
            photoArray = []
            currPageNumber = 1
        }
        .share()

        let nextResult = Observable.combineLatest(loadMoreProperty, orderByProperty).flatMapLatest { isLoadingMore, orderBy -> Observable<Result<[Photo], Splash.Error>> in
            guard isLoadingMore else { return .empty() }
            currPageNumber += 1
            return service.photos(byPageNumber: currPageNumber, orderBy: orderBy)
        }
        .share()
        
        let requestedPhotos = firstResult
        .merge(with: nextResult)
        .map { result -> [Photo]? in
            switch result {
                    
            case let .success(photos):
                return photos
            case let .failure(error):
                //FIXME: show alert
                return nil
            }
        }
        .unwrap()
        .map { photos -> [Photo] in
            photos.forEach {
                photoArray.append($0)
                
            }
            return photoArray
        }
        
        isRefreshing = refreshProperty
        isLoadingMore = loadMoreProperty
        isOrderBy = orderByProperty
        isFirstPageRequested = firstResult.map(to: true)
        
        homeViewCellModelTypes = Observable.combineLatest(requestedPhotos, cache.getAllObjects(ofType: Photo.self)).map { photos, cachedPhotos -> [Photo] in
            let cachedPhotos = cachedPhotos.filter {
                photos.contains($0)
            }
            
            return zip(photos, cachedPhotos).map { photo, cachedPhoto -> Photo in
                var photo = photo
                photo.likes = cachedPhoto.likes
                photo.likedByUser = cachedPhoto.likedByUser
                return photo
            }
        }.mapMany { HomeViewCellModel(photo: $0) }
    }
}
