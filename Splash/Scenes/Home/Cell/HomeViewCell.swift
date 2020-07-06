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
import RxNuke
import Nuke
import Hero

class HomeViewCell: UICollectionViewCell, BindableType {
    
    //MARK: - ViewModel -
    var viewModel: HomeViewCellModelType! {
        didSet {
            configureUI()
        }
    }
    
    private let stackView = UIStackView()
    private var headerView = HomeViewCellHeader()
    private var photoButton = UIButton()
    private let photoImageView = UIImageView()
    private var footerView = HomeViewCellFooter()
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
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
        
        headerView.bind(to: outputs.headerViewModelType)
        footerView.bind(to: outputs.footerViewModelType)
        
//        outputs.photoStream
//            .map { $0.id }
//            .unwrap()//fixme
//            .bind(to: photoImageView.rx.heroId)//fixme
            
        outputs.photoStream.bind { [weak self] in
            self?.photoButton.rx.bind(to: inputs.photoDetailsAction, input: $0)
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(outputs.smallPhotoUrl,
                                 outputs.regularPhotoUrl,
                                 outputs.fullPhotoUrl)
            .flatMap { smallPhotoURL, regularPhotoURL, fullPhotoURL -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: smallPhotoURL).asObservable(),
                    this.imagePipeline.rx.loadImage(with: regularPhotoURL).asObservable(),
                    this.imagePipeline.rx.loadImage(with: fullPhotoURL).asObservable()
                )
            }.orEmpty()
            .map { $0.image }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
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
        
        headerView.height(headerViewHeight)
        footerView.height(footerViewHeight)

        photoButton.isExclusiveTouch = true

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(footerView)
        
    }
}
