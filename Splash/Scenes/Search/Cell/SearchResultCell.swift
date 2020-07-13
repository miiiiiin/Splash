//
//  SearchResultCell.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

class SearchResultCell: UITableViewCell, BindableType, ClassIdentifiable {
    //MARK: ViewModel
    var viewModel: SearchResultCellModelType!
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: BindableType
    func bindViewModel() {
        viewModel.outputs.searchResult
            .map { $0.description }
            .bind(to: (textLabel?.rx.text)!)
            .disposed(by: disposeBag)
    }
}
