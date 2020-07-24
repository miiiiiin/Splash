//
//  SearchUsersViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/24.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchUsersViewController: UIViewController, BindableType {
    typealias SearchUsersSectionModel = SectionModel<String, UserCellModelType>
    
    //MARK: viewModel
    var viewModel: SearchUsersViewModel!
    
    private var tableView: UITableView!
//    private var loadingView: loadingview!//fixme
    private var dataSource: RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureLoadingView()
    }
    
    func bindViewModel() {
        let inputs = viewModel.input
        let outputs = viewModel.output
        
        outputs.navTitle
            .bind(to: rx.title)
        .disposed(by: disposeBag)
        
        outputs.usersViewModel
            .map { [SearchUsersSectionModel(model: "", items: $0)]}
            .execute { [unowned self] _ in
//                self.loadinview.stopania//fixme
                
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .bind(to: inputs.loadMore)
        .disposed(by: disposeBag)
    }
    
    //MARK: UI
    private func configureLoadingView() {
//        loadingView = LoadingView(frame: tableView.frame)//fixme
        //        loadingView.add(to: view).pinToEdges()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero)
        tableView.add(to: view).pinToEdges()
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.rowHeight = 60
        dataSource = RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>(configureCell: tableViewDataSource)
    }
    
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(withCellType: UserCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)
            return cell
        }
    }
}
