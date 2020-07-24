//
//  SearchCollectionsViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchCollectionsViewModelInput {
    
}

protocol SearchCollectionsViewModelOutput {
    
}

protocol SearchCollectionsViewModelType {
    var inputs: SearchCollectionsViewModelInput { get }
    var outputs: SearchCollectionsViewModelOutput { get }
}

final class SearchCollectionsViewModel: SearchCollectionsViewModelInput, SearchCollectionsViewModelOutput, SearchCollectionsViewModelType {
    
    //MARK: Input&Output
    var inputs: SearchCollectionsViewModelInput { return self }
    var outputs: SearchCollectionsViewModelOutput { return self }
    
    //MARK: Init
    init() {
        
    }
}
