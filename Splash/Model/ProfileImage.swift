//
//  ProfileImage.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/20.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

struct ProfileImage: Codable {
    
    let small: String?
    let medium: String?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
