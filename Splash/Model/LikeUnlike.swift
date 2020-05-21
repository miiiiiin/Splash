//
//  LikeUnlike.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct LikeUnlike: Codable {
    let photo: Photo?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case photo
        case user
    }
}
