//
//  SearchViewMode.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchViewModelInput {
    var searchString: BehaviorSubject<String?> { get }
    var searchTrigger: AnyObserver<Int>! { get }
}

protocol SearchViewModelOuput {
    var searchResultCellModel: Observable<[SearchResultCellModelType]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInput { get }
    var outputs: SearchViewModelOuput { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOuput {
    
    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOuput { return self }
    
    private let sceneCoordinator: SceneCoordinatorType
    private let searchResults: Observable<[SearchResult]>
    
    //MARK: Inputs
    var searchString = BehaviorSubject<String?>(value: nil)
    var searchTrigger: AnyObserver<Int>!
    
    //MARK: Outputs
    lazy var searchResultCellModel: Observable<[SearchResultCellModelType]> = {
        return searchResults.mapMany { SearchResultCellModel(searchResult: $0) }
    }()
    
    private lazy var searchAction: Action<Int, Void> = {
        return Action<Int, Void> { [weak self] row in
            guard let `self` = self,
                let query = try? self.searchString.value() else { return .empty() }
            switch row {
            case 0:
                let viewModel = SearchPhotosViewModel(type: .searchPhotos(searchQuery: query, searchService: SearchService()))
                return self.sceneCoordinator.transition(to: Scene.searchPhotos(viewModel))
            case 1:
                let viewModel = SearchCollectionsViewModel()
                return self.sceneCoordinator.transition(to: Scene.searchCollections(viewModel))
            case 2:
                let viewModel = SearchUsersViewModel(searchQuery: query)
                return self.sceneCoordinator.transition(to: Scene.searchUsers(viewModel))
            default:
                return .empty()
            }
        }
    }()
    
    //MARK: Init
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        let predefinedText = Observable.of(["photos with ", "Collections With", "Users with"])
        searchResults = Observable.combineLatest(predefinedText, searchString.unwrap())
            .map { predefinedText, query -> [SearchResult] in
                return predefinedText.map { SearchResult(query: query, predefinedText: $0)
            }
        }
        searchTrigger = searchAction.inputs
    }
}
