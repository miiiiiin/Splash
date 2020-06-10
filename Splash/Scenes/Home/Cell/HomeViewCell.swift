//
//  HomeViewCell.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HomeViewCell: UICollectionViewCell {
    
    //MARK: - ViewModel -
    var viewModel: HomeViewCellModelType {
        didSet {
            configureUI()
        }
    }
    
    private let stackView = UIStackView()
//    private let headerView = homeviewcellheader()
    private var photoButton = UIButton()
    private let photoImageView = UIImageView()
//    private let footerView = homeviewcellfooter()
    
//    private static let imagePipeline = Nuke.imagepipeline.shared
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoButton.rx.action = nil
        disposeBag = DisposeBag()
    }
    
    //MARK: - BindableType -
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = HomeViewCell.self
        
//        headerview.bind
//        footerview.bind
        
        outputs.photoStream
            .map { $0.id }
        .unwrap()
//            .bind(to: photoImageView.rx.alpha)
            .disposed(by: disposeBag)
        
        outputs.photoStream
            .bind { [weak self] in
                self?.photoButton.rx.bind(to: inputs.photoDetailsAction, input: $0)
        }.disposed(by: disposeBag)
//
//        Observable.combineLatest(outputs.smallPhotoUrl, outputs.regularPhotoUrl, outputs.fullPhotoUrl).flatMap { smallPhotoUrl, regularPhotoUrl, fullPhotoUrl -> Observable<ImageResponse> in
//            return Observable.concat(this.imagepipeline.rx.loadimage(width: ))
//        }
    }
    
    private func configureUI() {
        
        let headerViewHeight: CGFloat = 80.0
        let footerViewHeight: CGFloat = 60.0
        
        stackView.add(to: contentView).pinToEdges()
        photoButton.add(to: contentView)
            .top(to: \.topAnchor, constant: headerViewHeight)
            .bottom(to: \.bottomAnchor, constant: footerViewHeight)
            .left(to: \.leftAnchor)
            .right(to: \.rightAnchor)
        
    }
}
