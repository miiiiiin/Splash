//
//  SearchResultCellModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct SearchResult: Equatable {
    let query: String
    let description: String
    
    init(query: String, predefinedText: String) {
        self.query = query
        self.description = predefinedText + " \"\(query)\""
    }
}

extension SearchResult: IdentifiableType {
    var identity: String {
        return query
    }
}

//MARK: SearchResultCellModel

protocol SearchResultCellModelInput {}

protocol SearchResultCellModelOutput {
    var searchResult: Observable<SearchResult> { get }
}

protocol SearchResultModelType {
    var inputs: SearchResultCellModelInput { get }
    var outputs: SearchResultCellModelOutput { get }
}

final class SearchResultCellModel: SearchResultCellModelOutput, SearchResultCellModelInput, SearchResultModelType {
    
    //MARK: Inputs&Outputs
    var inputs: SearchResultCellModelInput { return self }
    var outputs: SearchResultCellModelOutput { return self }
    
    //MARK: Outputs
    let searchResult: Observable<SearchResult>
    
    init(searchResult: SearchResult) {
        self.searchResult = Observable.just(searchResult)
    }
}
