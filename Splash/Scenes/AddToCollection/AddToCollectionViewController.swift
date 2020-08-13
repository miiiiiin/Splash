//
//  AddToCollectionViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/08/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import Action
import Nuke
import RxNuke
import RxSwift

class AddToCollectionViewController: UIViewController, BindableType {
    typealias AddToCollectionSectionModel = SectionModel<String, PhotoCollectionCellModelType>
    
    //MARK: ViewModel
    var viewModel: AddToCollectionViewModelType!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<AddToCollectionSectionModel>!
    private let disposeBag = DisposeBag()
    private static let imagePipeLine = Nuke.ImagePipeline.shared
    private var cancelBarButton: UIBarButtonItem!
    private var addToCollectionBarButton: UIBarButtonItem!
    private var collectionViewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoImageView.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
        self.configureNavigationBar()
        self.configureCollectionView()
        self.configureCollectionViewActivityIndicator()
    }
    
    //MARK: UI
    private func configureNavigationBar() {
        title = "Add To Collection"
        cancelBarButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: nil)
        
        addToCollectionBarButton = UIBarButtonItem(
            image: Splash.Style.Icon.arrowUpRight,
            style: .plain,
            target: self,
            action: nil)
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = addToCollectionBarButton
        navigationController?.navigationBar.tintColor = .blue
    }
    
    private func configureCollectionViewActivityIndicator() {
        collectionViewActivityIndicator = UIActivityIndicatorView(style: .gray)
        collectionView.addSubview(collectionViewActivityIndicator)
        collectionViewActivityIndicator.center = CGPoint(x: collectionView.frame.width/2, y: collectionView.frame.height/2)
        collectionViewActivityIndicator.startAnimating()
        collectionViewActivityIndicator.hidesWhenStopped = true
    }
    
    private func configureCollectionView() {
        collectionView.register(cellType: PhotoCollectionViewCell.self)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.itemSize = CGSize(width: 100, height: 134)
        
        //todo
        dataSource = RxCollectionViewSectionedReloadDataSource<AddToCollectionSectionModel>(configureCell: collectionViewDataSource)
    }

    //todo
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = AddToCollectionViewController.self
        
        outputs.photoStream
            .map { $0.urls?.full }
            .unwrap()
            .mapToURL()
            .flatMap { this.imagePipeLine.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .execute { [unowned self] _ in
                self.photoActivityIndicator.stopAnimating()
        }
        .bind(to: photoImageView.rx.image)
        .disposed(by: disposeBag)
    
        outputs.collectionCellModelTypes
            .map { [AddToCollectionSectionModel(model: "", items: $0)]}
            .execute { [unowned self] _ in
                self.photoActivityIndicator.stopAnimating()
        }
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        cancelBarButton.rx.action = inputs.cancelAction
        addToCollectionBarButton.rx.action = inputs.navigateToCreateCollectionAction
    }
    
    //todo
    private var collectionViewDataSource: CollectionViewSectionedDataSource<AddToCollectionSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: PhotoCollectionViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)
            return cell
        }
    }
}
