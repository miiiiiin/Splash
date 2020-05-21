//
//  User.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let url: String?
    let location: String?
    let bio: String?
    let instagramUsername: String?
    let photos: [Photo]?
    let portfolio: String?
    let followers: Int?
    let following: Int?
    let followersCount: Int?
    let followingCount: Int?
    let portfolioUrl: String?
    let followedByUser: Bool?
    let totalPhotos: Int?
    let totalLikes: Int?
    let totalCollections: Int?
    let profileImage: ProfileImage?
    let downloads: Int?
    let links: Links?
    let uploadsRemaining: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case name
        case email
        case url
        case location
        case bio
        case instagramUsername = "instagram_username"
        case photos
        case portfolio
        case followers
        case following
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case portfolioUrl = "portfolio_url"
        case followedByUser = "followed_by_user"
        case totalPhotos = "total_photos"
        case totalLikes = "total_likes"
        case totalCollections = "total_collections"
        case profileImage = "profile_image"
        case downloads
        case links
        case uploadsRemaining = "uploads_remaining"
    }
}
