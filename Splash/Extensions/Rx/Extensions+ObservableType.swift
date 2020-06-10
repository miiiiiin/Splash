//
//  Extensions+ObservableType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func ignoreAll() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where Element == T? {
        return compactMap { $0 }
    }
}

extension Observable where Element == String {
    func mapToURL() -> Observable<URL> {
        return map { URL(string: $0) }.compactMap { $0 }
    }
}

extension Observable where Element == Data {
    func map<D: Decodable>(_ type: D.Type) -> Observable<D> {
        return map { try JSONDecoder().decode(type, from: $0) }
    }
}
