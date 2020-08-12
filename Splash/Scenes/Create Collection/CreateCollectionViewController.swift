//
//  CreateCollectionViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/08/12.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CreateCollectionViewController: UIViewController, BindableType {
    
    //MARK: viewModel
    var viewModel: CreateCollectionViewModelType!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    
    //MARK: UIBarButtonItem
    private var cancelBarButton: UIBarButtonItem!
    private var saveBarButton: UIBarButtonItem!
    private var activityIndicatorBarButton: UIBarButtonItem!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.nameTextField.becomeFirstResponder()
        self.configureNavigationBar()
    }
    
    func bindViewModel() { //todo
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        nameTextField.rx.text.orEmpty
            .bind(to: inputs.collectionName)
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.text.orEmpty
            .bind(to: inputs.collectionDescription)
            .disposed(by: disposeBag)
        
        privateSwitch.rx.isOn
            .bind(to: inputs.isPrivate)
            .disposed(by: disposeBag)
        
        outputs.saveButtonEnabled
            .bind(to: saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        inputs.saveAction.executing
            .subscribe { [unowned self] result in
            guard let isExecuting = result.element else { return }
            if isExecuting {
                self.navigationItem.rightBarButtonItem = self.activityIndicatorBarButton
            }
        }.disposed(by: disposeBag)
        
        cancelBarButton.rx.action = inputs.cancelAction
        saveBarButton.rx.action = inputs.saveAction
    }
    
    private func configureNavigationBar() {
        title = "New collection"
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        
        activityIndicatorBarButton = UIBarButtonItem(customView: activityIndicator)
        
        cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        
        saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        navigationController?.navigationBar.tintColor = .red
    }
}
