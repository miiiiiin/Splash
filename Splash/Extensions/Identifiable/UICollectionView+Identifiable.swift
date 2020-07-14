//
//  UICollectionView+Identifiable.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<C: UICollectionViewCell>(cellType: C.Type) where C: ClassIdentifiable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseId)
    }
    
    func register<C: UICollectionViewCell>(cellType: C.Type) where C: NibIdentifiable & ClassIdentifiable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseId)
    }
    
    func dequeueReusableCell<C: UICollectionViewCell>(withCellType type: C.Type = C.self, forIndexPath indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? C
            else {
                fatalError("Couldn't dequeue a UIcollectionViewell with identifier \(type.reuseId)")
        }
        return cell
    }
}
