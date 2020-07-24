//
//  SearchUsersViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import RxSwift
import Action

protocol SearchUsersViewModelInput {
    var loadMore: BehaviorSubject<Bool> { get }
}

protocol SearchUsersViewModelOutput {
    var searchQuery: Observable<String> { get }
    var totalResults: Observable<Int> { get }
    var usersViewModel: Observable<[UserCellModelType]> { get }
    var navTitle: Observable<String> { get }
}

protocol SearchUsersViewModelType {
    var input: SearchUsersViewModelInput { get }
    var output: SearchUsersViewModelOutput { get }
}

final class SearchUsersViewModel: SearchUsersViewModelInput, SearchUsersViewModelOutput, SearchUsersViewModelType {
  
    //MARK: Input&Output
    var input: SearchUsersViewModelInput { return self }
    var output: SearchUsersViewModelOutput { return self }
    
    //MARK: Inputs
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    //MARK: Outputs
    let searchQuery: Observable<String>
    let totalResults: Observable<Int>
    let navTitle: Observable<String>
    
    lazy var usersViewModel: Observable<[UserCellModelType]> = {
        return Observable.combineLatest(users, searchQuery)
            .map { users, searchQuery in
                users.map { UserCellModel.init(user: $0, searchQuery: searchQuery)
            }
        }
    }()
    
    private var users: Observable<[User]>!
    private var service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType
    
    init(searchQuery: String, service: SearchServiceType = SearchService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        self.searchQuery = Observable.just(searchQuery)
        
        var usersArray = [User]([])
        
        let firstUserSearchResult = service.searchUsers(with: searchQuery, pageNumber: 1)
        
        totalResults = firstUserSearchResult
            .map { $0.total }
            .unwrap()
        
        navTitle = Observable.zip(self.searchQuery, totalResults)
            .map { query, resultsNumber in
                return "\(query): \(resultsNumber) results"
        }
        
        let requestFirst = firstUserSearchResult
            .map { $0.results }
            .unwrap()
        
        let requestNext = loadMore
            .count()
            .flatMap { loadMore, count -> Observable<[User]> in
                guard loadMore else { return .empty() }
                return self.service.searchUsers(with: searchQuery, pageNumber: count)
                .map { $0.results }
                .unwrap()
        }
        
        users = Observable.merge(requestFirst, requestNext)
            .map { users -> [User] in
                users.forEach { user in
                    usersArray.append(contentsOf: usersArray)
                }
                return usersArray
        }
        
    }
}
