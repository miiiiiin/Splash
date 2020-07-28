//
//  UserCell.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit
import Nuke
import RxSwift

class UserCell: UITableViewCell, BindableType, NibIdentifiable & ClassIdentifiable {
    
    var viewModel: UserCellModelType!

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet var fullNameLbl: UILabel!
    
    private static let imagePipeLine = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profilePhotoImageView.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePhotoImageView.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = UserCell.self
        
        outputs.fullName
            .bind(to: fullNameLbl.rx.attributedText)
        .disposed(by: disposeBag)
        
        outputs.profilePhotoURL
            .flatMap { this.imagePipeLine.rx.loadImage(with: $0) }
        .orEmpty()
            .map { $0.image }
            .bind(to: profilePhotoImageView.rx.image)
        .disposed(by: disposeBag)
    }
}
