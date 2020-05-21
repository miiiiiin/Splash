//
//  Location.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/21.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

//MARK: - Location -
struct Location: Codable {
    let name: String?
    let city: String?
    let country: String?
    let position: Position?

    enum CodingKeys: String, CodingKey {
        case name
        case city
        case country
        case position
    }
}

//MARK: - Position -
struct Position: Codable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
