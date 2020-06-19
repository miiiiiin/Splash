//
//  HomeViewCellFooter.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import VanillaConstraints
import Nuke

class HomeViewCellFooter: UIView {
    
    
    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        stackView.addArrangedSubview(leftViewContainer)
        stackView.addArrangedSubview(rightViewContainer)
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(Splash.Style.Icon.bookmark, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
        return button
    }()
    
    private lazy var likesNumerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var leftViewContainer: UIView = {
        let view = UIView()
        
        
        
        return view
    }()
    
    private lazy var rightViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()
    
    
    private func configureUI() {
        stackViewContainer.add(to: self).pinToEdges()
    }
}


var viewModel: HomeViewCellFooterModelType! {
    didSet {
        configureUI()
    }
}


 // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        inputs.downloadPhotoAction.elements
            .subscribe { [unowned self] result in
                guard let linkString = result.element, let url = URL(string: linkString) else { return }
                Nuke.loadImage(with: url, into: self.dummyImageView) { result in
                    guard case let .success(response) = result else { return }
                    inputs.writeImageToPhotosAlbumAction.execute(response.image)
                }
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(outputs.isLikedByUser, outputs.photo)
            .bind { [weak self] in
                self?.likeButton.rx.bind(to: $0 ? inputs.unlikePhotoAction: inputs.likePhotoAction, input: $1)
            }
            .disposed(by: disposeBag)

        outputs.photo
            .bind { [weak self] in
                self?.saveButton.rx.bind(to: inputs.userCollectionsAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.photo
            .bind { [weak self] in
                self?.downloadButton.rx.bind(to: inputs.downloadPhotoAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.likesNumber
            .bind(to: likesNumberLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.isLikedByUser
            .map { $0 ? Papr.Appearance.Icon.heartFillMedium : Papr.Appearance.Icon.heartMedium }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)
    }

}
