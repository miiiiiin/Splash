//
//  PhotoCollectionViewCell.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/03.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Nuke

class PhotoCollectionViewCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

   //MARK: IBOUTLETS
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var addToCollectionButton: UIButton!
    @IBOutlet weak var collectionCoverImageView: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    
    //MARK: ViewModel
    var viewModel: PhotoCollectionCellModelType!
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    //MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        addToCollectionButton.isExclusiveTouch = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionCoverImageView.image = #imageLiteral(resourceName: "unsplash-icon-placeholder")
        addToCollectionButton.rx.action = nil
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionCoverImageView.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
        addToCollectionButton.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
    }
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = PhotoCollectionViewCell.self
        
        outputs.isPhotoInCollection
            .subscribe { result in
                guard let isPart = result.element else { return }
                self.addToCollectionButton.rx.action = isPart ? inputs.removeAction : inputs.addAction
        }
        .disposed(by: disposeBag)
        
        outputs.coverPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .execute { [unowned self] _ in
                self.indicator.stopAnimating()
            }
            .bind(to: collectionCoverImageView.rx.image)
            .disposed(by: disposeBag)
        
        outputs.collectionName
            .bind(to: collectionTitle.rx.text)
        .disposed(by: disposeBag)
        
        outputs.isPhotoInCollection
            .map { $0 ? .black : .clear }
            .bind(to: addToCollectionButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        outputs.isPhotoInCollection
            .map { $0 ? 0.6 : 1.0 }
            .bind(to: addToCollectionButton.rx.alpha)
            .disposed(by: disposeBag)
        
        outputs.isPhotoInCollection.map { $0 ? Splash.Style.Icon.arrowUpRight : nil }
            .bind(to: addToCollectionButton.rx.image())
        .disposed(by: disposeBag)
    }
}
