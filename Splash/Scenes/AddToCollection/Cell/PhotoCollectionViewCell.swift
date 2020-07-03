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

class PhotoCollectionViewCell: UITableViewCell, BindableType {
   
    
    //MARK: ViewModel
    var viewModel: PhotoCollectionCellModelType!
    
    //MARK: IBOUTLETS
    
    
    //MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    //MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bindViewModel() {
           //fixme
    }
}
