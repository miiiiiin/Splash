//
//  PhotoCollection.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct PhotoCollection: Codable {
    let id: Int?
    let title: String?
    let publishedAt: String?
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
    }
}
