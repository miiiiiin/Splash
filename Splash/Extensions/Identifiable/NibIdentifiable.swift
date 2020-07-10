//
//  NibIdentifiable.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

protocol NibIdentifiable: class {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibIdentifiable where Self: UIView {
    static func initFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self
            else {
                fatalError("Couldn't find nib file for \(self)")
        }
        return view
    }
}

extension NibIdentifiable where Self: UITableView {
    static func initFromNib() -> Self {
        guard let collectionView = nib.instantiate(withOwner: nil, options: nil).first as? Self
            else {
                fatalError("Couldn't find nib file for \(self)")
        }
        return collectionView
    }
}

extension UIViewController: NibIdentifiable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension NibIdentifiable where Self: UIViewController {
    static func initFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
}
