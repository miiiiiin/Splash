//
//  Scope.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/30.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

enum Scope: String, CaseIterable {
    case pub = "public"
    case readUser = "read_user"
    case writeUser = "write_user"
    case readPhotos = "read_photos"
    case writePhotos = "write_photos"
    case writeLikes = "write_likes"
    case writeFollowers = "write_followers"
    case readColletions = "read_collections"
    case writeCollections = "write_collections"
}
