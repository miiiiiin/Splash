//
//  HomeViewCellFooterModel.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/19.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Photos

protocol HomeViewCellFooterModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var downloadPhotoAction: Action<Photo, String> { get }
    var userCollectionsAction: Action<Photo, Void> { get }
    var writeImageToPhotosAlbumAction: Action<UIImage, Void> { get }
}

protocol HomeViewCellFooterModelOutput {
    var photo: Observable<Photo> { get }
    var likesNumber: Observable<String> { get }
    var isLikedByUser: Observable<Bool> { get }
}

protocol HomeViewCellFooterModelType {
    var inputs: HomeViewCellFooterModelInput { get }
    var outputs: HomeViewCellFooterModelOutput { get }
}

class HomeViewCellFooterModel: HomeViewCellFooterModelInput, HomeViewCellFooterModelOutput, HomeViewCellFooterModelType {
 
    var inputs: HomeViewCellFooterModelInput { return self }
    var outputs: HomeViewCellFooterModelOutput { return self }
    
    private let cache: Cache
    private let userService: UserServiceType
    private let photoService: PhotoServiceType
    private let photoLibrary: PHPhotoLibrary
    private let sceneCoordinator: SceneCoordinatorType

    //MARK: Input
    lazy var likePhotoAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            return self.photoService.like(photo: photo)
                .flatMap { [unowned self] result -> Observable<Photo> in
                switch result {
                case let .success(photo):
                    return .just(photo)
                case let .failure(error):
                    switch error {
                    case .noAccessToken:
                    self.navigateToLogin.execute(())
                    case let .other(message):
                    self.alertAction.execute((title: "Upsss...", message: message))
                    }
                    return .empty()
                }
            }
        }
    }()
    
    lazy var unlikePhotoAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            return self.photoService.unlike(photo: photo)
                .flatMap { [unowned self] result -> Observable<Photo> in
                switch result {
                case let .success(photo):
                    return .just(photo)
                case let .failure(error):
                    switch error {
                    case .noAccessToken:
                        self.navigateToLogin.execute(())
                    case let .other(message):
                        self.alertAction.execute((title: "Upsss...", message: message))
                    }
                    return .empty()
                }
            }
        }
    }()
    
    lazy var downloadPhotoAction: Action<Photo, String> = {
        Action<Photo, String> { [unowned self] photo in
            return self.photoService.photoDownloadLink(wihId: photo.id ?? "")
                .flatMap { [unowned self] result -> Observable<String> in
                switch result {
                case let .success(link):
                    return .just(link)
                case let .failure(error): break
                self.alertAction.execute((title: "Upsss...", message: error.localizedDescription))
                }
                return .empty()
            }
        }
    }()
    
    lazy var userCollectionsAction: Action<Photo, Void> = {
        Action<Photo, Void> { [unowned self] photo in
            return self.userService.getMe()
                .flatMap { result -> Observable<Void> in
                    switch result {
                    case let .success(user):
                        let viewModel = AddToCollectionViewModel(loggedInUser: user, photo: photo)
                        return self.sceneCoordinator.transition(to: Scene.addToCollection(viewModel))
                    case let .failure(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .other(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                        return .empty()
                    }
            }
        }
    }()
    
    lazy var writeImageToPhotosAlbumAction: Action<UIImage, Void> = {
        Action<UIImage, Void> { image in
            PHPhotoLibrary.requestAuthorization { [unowned self] authStatus in
                if authStatus == .authorized {
                    self.creationRequestForAsset(from: image)
                } else if authStatus == .denied {
                     self.alertAction.execute((
                                           title: "Upsss...",
                                           message: "Photo can't be saved! Photo Libray access is denied ⚠️"))
                }
            }
            return .empty()
        }
    }()
    
    //MARK: Outputs
    let photo: Observable<Photo>
    let likesNumber: Observable<String>
    let isLikedByUser: Observable<Bool>
    
    private lazy var alertAction: Action<(title: String, message: String), Void> = {
           Action<(title: String, message: String), Void> { [unowned self] (title, message) in
               let alertViewModel = AlertViewModel(
                   title: title,
                   message: message,
                   mode: .ok)
               return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
           }
       }()
    
    private lazy var navigateToLogin: CocoaAction = {
        CocoaAction { [unowned self] message in
            print("message: \(message)")
            let viewModel = LoginViewModel()
            return self.sceneCoordinator.transition(to: Scene.login(viewModel))
        }
    }()
    
    init(photo: Photo, cache: Cache = Cache.shared, userService: UserServiceType = UserService(), photoService: PhotoServiceType = PhotoService(), photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        
        self.cache = cache
        self.photoService = photoService
        self.userService = userService
        self.photoLibrary = photoLibrary
        self.sceneCoordinator = sceneCoordinator
        
        self.photo = Observable.just(photo)
        let cachedPhoto = cache.getObject(ofType: Photo.self, withid: photo.id ?? "").unwrap()
        
        likesNumber = self.photo.merge(with: cachedPhoto)
            .map { $0.likes?.abbreviatd }
            .unwrap()
        
        isLikedByUser = self.photo.merge(with: cachedPhoto)
            .map { $0.likedByUser }
            .unwrap()
    }
    
    private func creationRequestForAsset(from image: UIImage) {
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { [unowned self] success, error in
            if success {
                self.alertAction.execute((title: "Saved to Photos 🎉", message: ""))
            } else if let error = error {
                self.alertAction.execute((title: "Upsss...", message: error.localizedDescription + "😕"))
            } else {
                self.alertAction.execute((title: "Upsss...", message: "Unknown error 😱"))
            }
        })
    }
}
