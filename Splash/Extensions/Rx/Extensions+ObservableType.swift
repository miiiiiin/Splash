//
//  Extensions+ObservableType.swift
//  Splash
//
//  Created by Running Raccoon on 2020/06/10.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func ignoreAll() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where Element == T? {
        return compactMap { $0 }
    }
    
    func execute(_ selector: @escaping (Element) -> Void) -> Observable<Element> {
        return flatMap { result in
            return Observable
            .just(selector(result))
            .map { _ in result }
            .take(1)
        }
    }
    
    func merge(with other: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self.asObservable(), other)
    }
    
    func map<T>(to value: T) -> Observable<T> {
        print("map to value : \(value)")
        return map { _ in value }
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

extension ObservableType where Element: Collection {
    func mapMany<T>(_ transform: @escaping (Self.Element.Element) -> T) -> Observable<[T]> {
         print("transform: \(transform)")
        return self.map { collection -> [T] in
            collection.map(transform)
        }
    }
}
