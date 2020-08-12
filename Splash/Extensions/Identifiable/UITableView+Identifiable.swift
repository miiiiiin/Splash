//
//  UITableView+Identifiable.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/13.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) where T: ClassIdentifiable {
        print("register tableview celltype : \(cellType)")
        register(cellType.self, forCellReuseIdentifier: cellType.reuseId)
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) where T: NibIdentifiable & ClassIdentifiable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseId)
    }
    
    func dequeueResuableCell<T: UITableViewCell>(withCellType type: T.Type) -> T where T: NibIdentifiable & ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId) as? T else { fatalError("Couldn't dequeue a UITableViewCell with identifier: \(type.reuseId)")}
        return cell
    }
  
    func dequeueResuableCell<T: UITableViewCell>(withCellType type: T.Type = T.self, forIndexPath indexPath: IndexPath) -> T where T: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else { fatalError("Couldn't dequeue a UITableViewCell with identifier \(type.reuseId)") }
        return cell
    }
}
