//
//  SearchViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class SearchViewController: UIViewController, BindableType {
    
    typealias SearchSectionModel = SectionModel<String, SearchResultModelType>
    
    //MARK: - ViewModel -
    var viewModel: SearchResultModelType!
    
    @IBOutlet var tableView: UITableView!
    
    private var searchBar: UISearchBar!
    private var datasource: RxTableViewSectionedReloadDataSource<SearchSectionModel>!
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
//            var cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.self, for: indexPath)
//              cell.accessoryType = .disclosureIndicator
//            cell.bind(to: cellModel)
//
//            return cell
        }
    }
    private let disposeBag = DisposeBag()
    
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    //MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
    }
}

//    // MARK: Init
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureSearchBar()
//        configureTableView()
//        configureBouncyView()
//    }
//
//    // MARK: Overrides
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.searchBar.endEditing(true)
//    }
//
//    // MARK: BindableType
//
//    func bindViewModel() {
//        let inputs = viewModel.inputs
//        let outputs = viewModel.outputs
//
//        searchBar.rx.text
//            .unwrap()
//            .bind(to: inputs.searchString)
//            .disposed(by: disposeBag)
//
//        searchBar.rx.text
//            .unwrap()
//            .map { $0.count == 0 }
//            .bind(to: tableView.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        searchBar.rx.text
//            .unwrap()
//            .map { $0.count > 0 }
//            .bind(to: noResultView.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        outputs.searchResultCellModel
//            .map { [SearchSectionModel(model: "", items: $0)] }
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
//
//        tableView.rx.itemSelected
//            .execute { [unowned self] _ in
//                self.searchBar.endEditing(true)
//            }
//            .map { $0.row }
//            .bind(to: inputs.searchTrigger)
//            .disposed(by: disposeBag)
//    }
//
//    // MARK: UI
//
//    private func configureSearchBar() {
//        searchBar = UISearchBar()
//        searchBar.searchBarStyle = .default
//        searchBar.placeholder = "Search Unsplash"
//        navigationItem.titleView = searchBar
//
//        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//    }
//
//    private func configureTableView() {
//        tableView.tableFooterView = UIView()
//        tableView.rowHeight = 56
//        tableView.register(cellType: SearchResultCell.self)
//        dataSource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(
//            configureCell:  tableViewDataSource
//        )
//    }
//
//    private func configureBouncyView() {
//        let bouncyView = BouncyView(frame: noResultView.frame)
//        bouncyView.configure(emoji: "🏞", message: "Search Unsplash")
//        bouncyView.clipsToBounds = true
//        bouncyView.add(to: noResultView).pinToEdges()
//    }
//}
