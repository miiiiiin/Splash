//
//  PhotoStatistics.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct Stats: Decodable {
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case total
    }
}

struct PhotoStatistics: Decodable {
    let id: String?
    let downloads: Stats?
    let views: Stats?
    let likes: Stats?
    
    enum CodingKeys: String, CodingKey {
        case id
        case downloads
        case views
        case likes
    }
}

struct UserStatistics: Decodable {
    let username: String?
    let downloads: Stats?
    let views: Stats?
    let likes: Stats?
    
    enum CodingKeys: String, CodingKey {
        case username
        case downloads
        case views
        case likes
    }
}
