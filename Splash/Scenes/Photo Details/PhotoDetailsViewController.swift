//
//  PhotoDetailsViewController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/08/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Nuke
import UIKit

class PhotoDetailsViewController: UIViewController, BindableType {
    
    //MARK: ViewModel
    var viewModel: PhotoDetailsViewModelType!
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var totalViewsImageView: UIImageView!
    @IBOutlet weak var totalViewsLabel: UILabel!
    @IBOutlet weak var statsContainerView: UIStackView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var downloadimageView: UIImageView!
    @IBOutlet weak var totalDownloadsLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var dismissButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var statsContainerViewBottomConstraint: NSLayoutConstraint!
    
    func bindViewModel() {
        <#code#>
    }
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()
    private var isTouched = true
    private var scrollView: UIScrollView!
    private var photoImageView: UIImageView!
    private var tapGesture: UITapGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!
    private var dismissGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK: UI
    private func configureAll() {
        likeBtn.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
        likeBtn.imageView?.contentMode = .scaleAspectFit
        likeBtn.tintColor = .white
        
        let eyeImage = Splash.Style.Icon.arrowUpRight
        let downloadImage = Splash.Style.Icon.arrowUpRight
        
        totalViewsImageView.image = eyeImage
        downloadImage.image = downloadImage
        
        totalViewsImageView.image = eyeImage.withRenderingMode(.alwaysTemplate)
        downloadimageView.image = downloadImage.withRenderingMode(.alwaysTemplate)
        
        totalViewsImageView.tintColor = .white
        downloadimageView.tintColor = .white
        
        moreBtn.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
        dismissBtn.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
        dismissBtn.imageView?.contentMode = .scaleAspectFit
        
        configureScrollView()
        configurePhotoImageView()
        configureTapGestures()
        configureDismissGesture()

        view.bringSubviewToFront(dismissBtn)
        view.bringSubviewToFront(statsContainerView)
    }
    
    private func configureTapGestures() { //fixme
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideover))
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        scrollView.contentMode = .center
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.add(to: view).pinToEdges()
    }
    
    private func configurePhotoImageView() {
        photoImageView = UIImageView(frame: view.bounds)
        photoImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(photoImageView)
    }
    
    private func configureDismissGesture() {
        dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissController))
        view.addGestureRecognizer(dismissGesture)
    }
    
    private func configureContentSize(withHeight height: CGFloat) {
        let bounds = view.bounds
        scrollView.frame = bounds
        let size = CGSize(width: UIScreen.main.bounds.width, height: height)
        photoImageView.frame = CGRect(origin: .zero, size: size)
        scrollView.contentSize = size //todo
    }
    
    @objc private func showHideOverlays(withDelay delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3) {
                [unowned self] in
                if self.isTouched {
                    self.statsContainerViewBottomConstraint.constant = 0
                    self.dismissButtonTopConstraint.constant = 15
                    self.isTouched = false
                } else {
                    self.hideOverlays()
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func hideOverlays() {
        self.statsContainerViewBottomConstraint.constant = 132
        self.dismissButtonTopConstraint.constant = -100
        self.isTouched = true
    }
    
//    @objc private func zoomInOut(gestureRecognizer: UITapGestureRecognizer) {
//        if scrollView.zoomScale == 1 {
//            scrollView.zoom(to: zoomre, animated: <#T##Bool#>)
//        }
//    }
    
    @objc private func zoomOut() {
        scrollView.setZoomScale(1, animated: true)
    }
    
    @objc private func dismissController() {
        if scrollView.zoomScale > 1 { return }
        
//        let translation = dismissGesture.transla
    }
}
