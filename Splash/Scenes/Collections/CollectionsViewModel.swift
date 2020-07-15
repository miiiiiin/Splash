//
//  CollectionsViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/14.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol CollectionsViewModelInput {
    var loadMore: BehaviorSubject<Bool> { get }
    
    // Call when pull-to-refresh is invoked
    func refresh()
    
    // Call when a collection is selected
    var collectionDetailsAction: Action<PhotoCollection, Void> { get }
}

protocol CollectionsViewModelOutput {
    var isRefreshing: Observable<Bool> { get }
    var collectionCellsModelType: Observable<[CollectionCellViewModelType]> { get }
}

protocol CollectionsViewModelType {
    var input: CollectionsViewModelInput { get }
    var output: CollectionsViewModelOutput { get }
}

final class CollectionsViewModel: CollectionsViewModelOutput, CollectionsViewModelInput, CollectionsViewModelType {
    
    //MARK: Input&Output
    var input: CollectionsViewModelInput { return self }
    var output: CollectionsViewModelOutput { return self }
    
    //MARK: Inputs
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    func refresh() {
        refreshProperty.onNext(true)
    }
    
    //MARK: Output
    var isRefreshing: Observable<Bool>
      
    lazy var collectionCellsModelType: Observable<[CollectionCellViewModelType]> = {
        return photoCollections.mapMany { CollectionCellVieModel(photoCollection: $0
            )}
    }()
    
    lazy var collectionDetailsAction: Action<PhotoCollection, Void> = {
        return Action<PhotoCollection, Void> { [unowned self] collection in
//            let viewModel = searchphot
//            let viewModel = SearchPhotosViewModel(type:
            //                .collectionPhotos(
            //                    title: collection.title ?? "",
            //                    collectionID: collection.id ?? 0,
            //                    collectionService: CollectionService()
            //                )
            //            )
            //            return self.sceneCoordinator.transition(to:Scene.searchPhotos(viewModel))
            
            self.sceneCoordinator.transition(to: Scene.login)
            //fixme
        }
    }()
    
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var photoCollections: Observable<[PhotoCollection]>!
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    
    
    //MARK: Init
    init(service: CollectionServiceType = CollectionService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        
        var currentPageNumber = 1
        var collectionArray = [PhotoCollection]()
        
        isRefreshing = refreshProperty.asObservable()
        
        let requestFirst = isRefreshing
            .flatMapLatest { isRefreshing -> Observable<[PhotoCollection]> in
                guard isRefreshing else { return .empty() }
                return service
                .collection(byPageNumber: 1)
                .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                    switch result {
                    case let .success(photoCollections):
                        return .just(photoCollections)
                    case let .failure(error):
                        self.refreshProperty.onNext(false)
                        return .empty()
                    }
                }
        }.do(onNext: { _ in
            collectionArray = []
            currentPageNumber = 1
        })
        
        let requestNext = loadMore.asObservable()
            .flatMapLatest { isLoadingMore -> Observable<[PhotoCollection]> in
                guard isLoadingMore else { return .empty() }
                currentPageNumber += 1
                
                return service
                .collection(byPageNumber: currentPageNumber)
                    .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                        switch result {
                        case let .success(photoCollections):
                            return .just(photoCollections)
                        case let .failure(error):
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                }
        }
        
        photoCollections = requestFirst
            .merge(with: requestNext)
            .map { [unowned self] collections -> [PhotoCollection] in
                collections.forEach { collection in
                    collectionArray.append(collection)
                }
                self.refreshProperty.onNext(false)
                return collectionArray
        }
    }
}
