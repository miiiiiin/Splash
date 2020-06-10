//
//  HomeViewCellModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/27.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol HomeViewCellModelInput {
    
    var photoDetailsAction: Action<Photo, Photo> { get }
}

protocol HomeViewCellModelOutput {
    var photoStream: Observable<Photo> { get }
    var smallPhotoUrl: Observable<URL> { get }
    var regularPhotoUrl: Observable<URL> { get }
    var fullPhotoUrl: Observable<URL> { get }
    var photoSize: Observable<(Double, Double)> { get }
    var extraHeight: Observable<Double> { get }
}


protocol HomeViewCellModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}


class HomeViewCellModel: HomeViewCellModelType, HomeViewCellModelInput, HomeViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    var outputs: HomeViewCellModelOutput { return self }
    
    // MARK: Inputs
    var photoDetailsAction: Action<Photo, Photo>
    
    // MARK: Output
    var photoStream: Observable<Photo>
    var smallPhotoUrl: Observable<URL>
    var regularPhotoUrl: Observable<URL>
    var fullPhotoUrl: Observable<URL>
    var photoSize: Observable<(Double, Double)>
    var extraHeight = Observable<Double>.just(70)
    
    // MARK: Private
    private let photo: Photo
    private let sceneCoordinator: SceneCoordinatorType
    
    
    init(photo: Photo, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.sceneCoordinator = sceneCoordinator
        
        self.photoStream = Observable.just(photo)
        
        smallPhotoUrl = photoStream
            .map { $0.urls?.small }
            .asObservable()
            
        
        regularPhotoUrl = photoStream
            .map { $0.urls?.regular }
            .asObservable()
        
        fullPhotoUrl = photoStream
            .map { $0.urls?.full }
            .asObservable()
        
        let height = photoStream
            .map { $0.height }
        
        let width = photoStream
            .map { $0.width }
        
        photoSize = Observable.combineLatest(width, height, extraHeight).map { width, height, extraHeight in
            return (Double(UIScreen.main.bounds.width), height / width + 2 * extraHeight)
        }
    }
}
