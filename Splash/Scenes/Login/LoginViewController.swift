//
//  loginViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/31.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, BindableType {
    
    var viewModel: LoginViewModelType!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    
    private static let imagePipeLine = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
        imageView.dim(withAlpha: 0.1)
        imageView.image = nil
        imageView.image = UIImage(named: "placeholder_wallpaper")
        closeBtn.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //TODO
    func bindViewModel() {
        
        let this = LoginViewController.self
        
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        loginBtn.rx.action = inputs.loginAction
        closeBtn.rx.action = inputs.closeAction
        
        outputs.buttonName
            .bind(to: loginBtn.rx.title())
        .disposed(by: disposeBag)
        
        outputs.loginState
            .map { $0 == .idle }
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        outputs.loginState
            .map { $0 == .idle ? 1.0 : 0.9 }
            .bind(to: loginBtn.rx.alpha)
            .disposed(by: disposeBag)
            
        outputs.randomPhotos
            .map { $0.compactMap { $0.urls?.regular } }
            .mapMany { this.imagePipeLine.rx.loadImage(with: URL(string: $0)!).asObservable().orEmpty() }
            .mapMany { $0.map { $0.image } }
            .flatMap(Observable.combineLatest)
            .map { UIImage.animatedImage(with: $0, duration: 60.0) }
        .unwrap()
            .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
}
