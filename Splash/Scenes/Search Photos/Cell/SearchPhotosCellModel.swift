//
//  SearchPhotosCellModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Nuke
import RxCocoa

protocol SearchPhotosCellModelInput {
    
}

protocol SearchPhotosCellModelOutput {
    var photoStream: Observable<Photo> { get }
    var smallPhotoURL: Observable<URL> { get }
    var regularPhotURL: Observable<URL> { get }
    var photoSize: Observable<(Double, Double)> { get }
}

protocol SearchPhotosCellModelType {
    var inputs: SearchPhotosCellModelInput { get }
    var outputs: SearchPhotosCellModelOutput { get }
}

final class SearchPhotosCellModel: SearchPhotosCellModelInput, SearchPhotosCellModelOutput, SearchPhotosCellModelType {
    
    //MARK: Inputs&Outputs
    var inputs: SearchPhotosCellModelInput { return self }
    var outputs: SearchPhotosCellModelOutput { return self }
    
    //MARK: Output
    let photoStream: Observable<Photo>
    let smallPhotoURL: Observable<URL>
    let regularPhotURL: Observable<URL>
    let photoSize: Observable<(Double, Double)>
 
    //MARK: Init
    init(photo: Photo) {
        photoStream = Observable.just(photo)
        
        smallPhotoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()
            .mapToURL()
        
        regularPhotURL = photoStream
            .map { $0.urls?.regular }
        .unwrap()
        .mapToURL()
        
        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )
    }
}
