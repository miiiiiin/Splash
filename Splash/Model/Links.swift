//
//  Links.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct Links: Codable {
    let selfLink: String?
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    let download: String?
    let downloadLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case photos
        case likes
        case portfolio
        case download
        case downloadLocation = "download_location"
    }
}

struct Link: Decodable {
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
