//
//  SearchPhotosCell.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Nuke

class SearchPhotosCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {
    
    var viewModel: SearchPhotosCellModelType!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = SearchPhotosCell.self

        outputs.photoStream
            .map { $0.id }
            .unwrap()
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)

        //fixme
//        Observable.combineLatest(outputs.smallPhotoURL, outputs.regularPhotoURL)
//            .flatMap { smallPhotoURL, regularPhotoURL -> Observable<ImageResponse> in
//                return Observable.concat(
//                    this.imagePipeline.rx.loadImage(with: smallPhotoURL).asObservable(),
//                    this.imagePipeline.rx.loadImage(with: regularPhotoURL).asObservable()
//                )
//            }
//            .orEmpty()
//            .map { $0.image }
//            .execute { [unowned self] _ in
//                self.indicator.stopAnimating()
//            }
//            .bind(to: photoImageView.rx.image)
//            .disposed(by: disposeBag)
    }
}
