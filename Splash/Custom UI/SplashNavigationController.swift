//
//  SplashNavigationController.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/08.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import RxSwift
import Action

class SplashNavigationController: UINavigationController {
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    
    private var service: UserServiceType!
    private var sceneCoordinator: SceneCoordinatorType!
    
    private lazy var showUserProfilAction: CocoaAction = {
//       let viewModel = userprofile
//        let viewModel = UserProfileViewModel()
        //         return CocoaAction { [unowned self] in
        //             self.sceneCoordiantor.transition(to: Scene.userProfile(viewModel))
        //         }//fixme
        
        return CocoaAction { [unowned self] in
            self.sceneCoordinator.transition(to: Scene.login)
        }
    }()
    
//    private lazy var showUserProfileAction: CocoaAction = {
//          let viewModel = UserProfileViewModel()
//          return CocoaAction { [unowned self] in
//              self.sceneCoordiantor.transition(to: Scene.userProfile(viewModel))
//          }
//      }()


    // MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rootViewController: UIViewController, service: UserServiceType = UserService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        super.init(rootViewController: rootViewController)
        self.service = service
        self.sceneCoordinator = sceneCoordinator
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
     
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationBar.tintColor = .black
        navigationBar.isTranslucent = false
        
        let profileImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        profileImage.isHidden = true
        profileImage.roundCorners(withRadius: Splash.Style.Layer.imageCornersRadius)
        
        var button = UIButton(frame: .zero)
        button.add(to: profileImage).size(profileImage.frame.size).pinToEdges()
        
        let profileImageBarButtonItem = UIBarButtonItem(customView: profileImage)
        button.rx.action = showUserProfilAction
        
        topViewController?.navigationItem.leftBarButtonItem = profileImageBarButtonItem
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        service.getMe()
            .map { result -> User? in
                switch result {
                case let.success(user):
                    profileImage.isHidden = false
                    return user
                case .failure:
                    return nil
                }
        }
    .unwrap()
        .map { $0.profileImage?.medium }
    .unwrap()
    .mapToURL()
        .flatMap { SplashNavigationController.imagePipeline.rx.loadImage(with: $0)}
    .orEmpty()
        .map { $0.image }
        .bind(to: profileImage.rx.image)
    .disposed(by: disposeBag)
    }
}
