//
//  PhotoCollection.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import RxDataSources

struct PhotoCollection: Codable {
    let id: Int?
    let title: String?
    let publishedAt: String?
    let isPrivate: Bool?
    let updatedAt: String?
    let coverPhoto: Photo?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
        case isPrivate = "private"
    }
}

extension PhotoCollection: IdentifiableType {
    typealias Identity = Int
    
    var identity: Identity {
        guard id != nil else { return -999 }
        return id!
    }
}

struct CollectionResponse: Decodable {
    let photo: Photo?
    let collection: PhotoCollection?
    let user: User?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case photo
        case collection
        case user
        case createdAt = "created_at"
    }
}
