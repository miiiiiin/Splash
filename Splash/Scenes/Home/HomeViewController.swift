//
//  HomeViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import VanillaConstraints

class HomeViewController: UIViewController, BindableType {
    
    //MARK: - RxDataSources Model -
    typealias HomeSectionModel = SectionModel<String, HomeViewCellModelType>
    
    //MARK: - ViewModel -
    var viewModel: HomeViewModel!

    private let disposeBag = DisposeBag()
    private let collectionLayout: UICollectionViewLayout!
    private var datasource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private var rightBarButtonItem: UIBarButtonItem!
    private var collectionViewDataSource: CollectionViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { _, collectionView, IndexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: IndexPath)//fixme
//            cell.bind(to: cellModel)//fixme
//
//            if let pinterestLayout = collectionView.collectionViewLayout as? PinterestLayout {
//                cellModel.outputs.photoSize
//                    .map { CGSize(width: $0, height: $1) }
//                    .bind(to: pinterestLayout.rx.updateSize(IndexPath))
//                    .disposed(by: self.disposeBag)
//            }//fixme
            return cell
        }
    }
    
    init(collectionViewLayout: UICollectionViewLayout) {
        //fixme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let rightBarButtonItemTap = rightBarButtonItem.rx.tap.share()
        
        rightBarButtonItemTap
            .scan(into: OrderBy.latest) { result, _ in
                result = (result == .latest) ? .popular : .latest
        }
        .bind(to: inputs.orderByProperty)
        .disposed(by: disposeBag)
        
        rightBarButtonItemTap
            .merge(with: refreshControl.rx.controlEvent(.valueChanged).asObservable())
            .map(to: true)
            .bind(to: inputs.refreshProperty)
        .disposed(by: disposeBag)
        
//        collectionView.rx.reachedBottom()
//            .bind(to: inputs.loadMoreProperty)
//            .disposed(by: disposeBag)//fixme
        
        outputs.isOrderBy
            .map { $0 == .popular ? Splash.Style.Icon.bookmark : Splash.Style.Icon.arrowUpRight }
//            .bind(to: rightBarButtonItem.rx.image)//fixme
//        .disposed(by: disposeBag)
        
        outputs.isFirstPageRequested
//        .negate()//fixme
            .bind(to: inputs.refreshProperty)
        .disposed(by: disposeBag)
        
        outputs.isRefreshing
            .merge(with: outputs.isLoadingMore)
//        .negate()//fixme
            .bind(to: rightBarButtonItem.rx.isEnabled)
        .disposed(by: disposeBag)
        
//        outputs.isRefreshing
//            .bind(to: refreshControl.rx.isRefreshing(in: collectionView))//fixme
//        .disposed(by: disposeBag)
            
        outputs.homeViewCellModelTypes
            .map { [HomeSectionModel(model: "", items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    //MARK: UI
    private func configureNavigationController() {
        rightBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.add(to: view).pinToEdges()
//        collectionView.register(cellType: HomeViewCell.self)//fixme
        datasource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(configureCell: collectionViewDataSource)
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        collectionView.addSubview(refreshControl)
    }
}
