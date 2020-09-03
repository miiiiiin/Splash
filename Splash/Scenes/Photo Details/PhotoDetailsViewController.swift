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
import Hero
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
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()
    private var isTouched = true
    private var scrollView: UIScrollView!
    private var photoImageView: UIImageView!
    private var tapGesture: UITapGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!
    private var dismissGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAll()
        showHideOverlays(withDelay: 0.5)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
        centerScrollViewIfNeeded()
    }
    
    //MARK: UI
    private func configureAll() {
        likeBtn.setImage(Splash.Style.Icon.arrowUpRight, for: .normal)
        likeBtn.imageView?.contentMode = .scaleAspectFit
        likeBtn.tintColor = .white
        
        let eyeImage = Splash.Style.Icon.arrowUpRight
        let downloadImage = Splash.Style.Icon.arrowUpRight
        
        totalViewsImageView.image = eyeImage
        downloadimageView.image = downloadImage
        
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
    
    private func configureTapGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHideOverlays(withDelay:)))
        
        tapGesture.addTarget(self, action: #selector(zoomOut))
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomInOut(gestureRecognizer:)))
        
        doubleTapGesture.addTarget(self, action: #selector(hideOverlays))
        
        tapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        
        tapGesture.delegate = self
        doubleTapGesture.delegate = self
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(doubleTapGesture)
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
    
    //todo
    @objc private func zoomInOut(gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRect(
                forScale: scrollView.maximumZoomScale,
                withCenter: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            zoomOut()
        }
    }
    
    @objc private func zoomOut() {
        scrollView.setZoomScale(1, animated: true)
    }
    
    @objc private func dismissController() { //todo
        if scrollView.zoomScale > 1 { return }
        
        let translation = dismissGesture.translation(in: nil)
        let progress = abs(translation.y/view.bounds.height) * 1.5
        
        switch dismissGesture.state {
        case .began:
            Hero.shared.defaultAnimation = .fade
            viewModel.input.dismissAction.execute(())
            
        case .changed:
            Hero.shared.update(progress)
            let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)], to: photoImageView) //todo
            
        default:
            if progress + dismissGesture.velocity(in: nil).y / view.bounds.height < 0.3 {
                Hero.shared.finish()
            } else {
                viewModel.input.revertAction.execute(())
                Hero.shared.cancel()
            }
        }
    }
    
    private func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = photoImageView.frame.size.height / scale
        zoomRect.size.width = photoImageView.frame.size.width / scale
        
        let newCenter = photoImageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    private func centerScrollViewIfNeeded() {
        var inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if scrollView.contentSize.height < scrollView.bounds.height {
            let insetV = (scrollView.bounds.height - scrollView.contentSize.height) / 2
            inset.top += insetV //todo
            inset.bottom = insetV
        }
        
        if scrollView.contentSize.width < scrollView.bounds.width {
            let insetV = (scrollView.bounds.width - scrollView.contentSize.width) / 2
            inset.left = insetV
            inset.right = insetV
        }
        scrollView.contentInset = inset
    }
}

extension PhotoDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewIfNeeded()
    }
}

extension PhotoDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.tapGesture && otherGestureRecognizer == self.doubleTapGesture
    }
    
    
    
    func bindViewModel() { //todo
        let inputs = viewModel.input
        let outputs = viewModel.output
        let this = PhotoDetailsViewController.self
        
        dismissBtn.rx.action = inputs.dismissAction
        
        outputs.photoStream
            .map { $0.id }
        .unwrap()
            .bind(to: photoImageView.rx.heroId)
        .disposed(by: disposeBag)
        
        outputs.regularPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
        .orEmpty()
            .map { $0.image }
            .bind(to: photoImageView.rx.image)
        .disposed(by: disposeBag)
        
        outputs.photoSize
            .map { size -> CGFloat in
                let (width, height) = size
                return CGFloat(height * Double(UIScreen.main.bounds.width) / width)
        }
        .bind(onNext: { [weak self] in //todo
            self?.configureContentSize(withHeight: $0)
            
        })
        .disposed(by: disposeBag)
     
        outputs.likedByUser
            .map { $0 ? Splash.Style.Icon.bookmark : Splash.Style.Icon.arrowUpRight }
            .bind(to: likeBtn.rx.image())
            .disposed(by: disposeBag)
        
        outputs.totalViews
            .bind(to: totalViewsLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.totalLikes
            .bind(to: totalLikesLabel.rx.text)
            .disposed(by: disposeBag)
    
        outputs.totalDownloads
            .bind(to: totalDownloadsLabel.rx.text)
            .disposed(by: disposeBag)
            
        Observable.combineLatest(outputs.likedByUser, outputs.photoStream)
        .bind(onNext: { [weak self] in
            self?.likeBtn.rx.bind(to: $0 ? inputs.unlikePhotoAction : inputs.likePhotoAction, input: $1)
        })
        .disposed(by: disposeBag)
        
        
        outputs.photoStream
            .map { $0.links?.html }
            .unwrap()
            .bind { [weak self] in
                guard let image = self?.photoImageView.image else { return }
                self?.moreBtn.rx.bind(to: inputs.moreAction, input: [$0, image])
            }
            .disposed(by: disposeBag)
    }
}
