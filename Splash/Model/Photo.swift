//
//  Photo.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxDataSources

struct Photo: Codable {
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let downloads: Int?
    var likes: Int?
    var likedByUser: Bool?
    let description: String?
    let location: Location?
    let views: Int?
//    let tags: [Tag]?
    let currentUserCollections: [PhotoCollection]?
    let urls: ImageURLs?
    let exif: Exif?
    let links: Links?
    let user: User?
//    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case downloads
        case likes
        case likedByUser = "liked_by_user"
        case description
        case location
        case views
//        case tags
        case currentUserCollections = "current_user_collections"
        case urls
        case exif
        case links
        case user
//        case categories
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        guard let id = id else { fatalError("The photo id shouldn't be nil") }
        return id
    }
}

extension Photo: Cacheable {
    var identifier: String {
        guard let id = id else {
            fatalError("The photo id shouldn't be nil")
        }
        return id
    }
}
