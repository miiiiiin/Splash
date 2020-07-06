//
//  HomeViewCellHeader.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Nuke
import RxNuke

class HomeViewCellHeader: UIView, BindableType {
    
    var viewModel: HomeViewCellHeaderModelType! {
        didSet {
            configureUI()
        }
    }
    
    private lazy var profileImageView = UIImageView()
    private lazy var stackView = UIStackView()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17.9, weight: .regular)
        return label
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private var updatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private static let imagePipeLine = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
    
        let outputs = viewModel.outputs
        let this = HomeViewCellHeader.self

        outputs.profileImageURL
            .flatMap { this.imagePipeLine.rx.loadImage(with: $0)}
            .orEmpty()
            .map { $0.image }
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.fullName
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.userName
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.updatedTime
            .bind(to: updatedTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        
        profileImageView.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
        
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(fullNameLabel)
        stackView.addArrangedSubview(userNameLabel)
        
        profileImageView.add(to: self)
            .left(to: \.leftAnchor, constant:  16.0)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 48.0, height: 48.0))
        
        stackView.add(to: self)
            .left(to: \.rightAnchor, of: profileImageView, constant: 16.0)
            .centerY(to: \.centerYAnchor)
        
        updatedTimeLabel.add(to: self)
            .right(to: \.rightAnchor, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .left(to: \.rightAnchor, of: stackView, constant: 8.0)
    }
}
