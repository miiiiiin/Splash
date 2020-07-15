//
//  CollectionCellViewModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/14.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol CollectionCellViewModelInput {}
protocol CollectionCellViewModelOutput {
    var photoCollection: Observable<PhotoCollection> { get }
}

protocol CollectionCellViewModelType {
    var input: CollectionCellViewModelInput { get }
    var output: CollectionCellViewModelOutput { get }
}

final class CollectionCellVieModel: CollectionCellViewModelInput, CollectionCellViewModelOutput, CollectionCellViewModelType {
  
    //MARK: Input&Output
    var input: CollectionCellViewModelInput { return self }
    var output: CollectionCellViewModelOutput { return self }
    
    //MARK: Output
    let photoCollection: Observable<PhotoCollection>
    
    //MARK: Init
    init(photoCollection: PhotoCollection) {
        self.photoCollection = Observable.just(photoCollection)
    }
}
