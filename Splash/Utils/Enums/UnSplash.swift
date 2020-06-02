//
//  Splash.swift
//  Splash
//
//  Created by Running Raccoon on 2020/05/28.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation

enum UnSplash {
    
    case getUser
    case updateUser(
        username: String?,
        firstName: String?,
        lastName: String?,
    )
    
}
/// Get the user's profile
    case getMe

    /// Update the current user’s profile
    case updateMe(
        username: String?,
        firstName: String?,
        lastName: String?,
        email: String?,
        url: String?,
        location: String?,
        bio: String?,
        instagramUsername:
        String?)

    /// Get a user’s public profile
    case userProfile(
        username: String,
        width: Int?,
        height: Int?)

    /// Get a user’s portfolio link
    case userPortfolio(username: String)

    /// List a user’s photos
    case userPhotos(
        username: String,
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?,
        showStats: Bool?,
        resolution: Resolution?,
        quantity: Int?)

    /// List a user’s liked photos
    case userLikedPhotos(
        username: String,
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// List a user’s collections
    case userCollections(
        username:String,
        page: Int?,
        perPage: Int?)

    /// Get a user’s statistics
    case userStatistics(
        username: String,
        resolution: Resolution?,
        quantity: Int?)

    /// Get the list of all photos
    case photos(
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// Retrieve a single photo.
    case photo(
        id: String,
        width: Int?,
        height: Int?,
        rect: [Int]?)

    /// Get a random photo
    case randomPhoto(
        collections: [String]?,
        isFeatured: Bool?,
        username: String?,
        query: String?,
        width: Int?,
        height: Int?,
        orientation: Orientation?,
        count: Int?)

    /// Get a photo’s statistics
    case photoStatistics(
        id: String,
        resolution: Resolution?,
        quantity: Int?)

    /// Retrieve a single photo’s download link
    case photoDownloadLink(id: String)

    /// Like a photo on behalf of the logged-in user
    case likePhoto(id: String)

    /// Remove a user’s like of a photo.
    case unlikePhoto(id: String)

    /// Get photo results for a query
    case searchPhotos(
        query: String,
        page: Int?,
        perPage: Int?,
        collections: [String]?,
        orientation: Orientation?)

    /// Get collection results for a query
    case searchCollections(
        query: String,
        page: Int?,
        perPage: Int?)

    /// Get user results for a query
    case searchUsers(
        query: String,
        page: Int?,
        perPage: Int?)

    /// Get a list of all collections
    case collections(
        page: Int?,
        perPage: Int?)

    /// Get a list of featured collections
    case featuredCollections(
        page: Int?,
        perPage: Int?)

    /// Retrieve a collection
    case collection(id: Int)

    /// Retrieve a related collection
    case relatedCollections(id: Int)

    /// Retrieve a collection’s photos
    case collectionPhotos(
        id: Int,
        page: Int?,
        perPage: Int?)

    /// Create a new collection
    case createCollection(
        title: String,
        description: String?,
        isPrivate: Bool?)

    /// Update an existing collection
    case updateCollection(
        id: Int,
        title: String?,
        description: String?,
        isPrivate: Bool?)

    /// Delete an existing collection
    case deleteCollection(id: Int)

    /// Add a photo to a collection
    case addPhotoToCollection(
        collectionID: Int,
        photoID: String)

    /// Remove a photo from a collection
    case removePhotoFromCollection(
        collectionID: Int,
        photoID: String)

    // MARK: - TODO: Support these cases
    // id(required)
    // case updatePhoto(String)
}

extension Unsplash: Resource {

    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("FAILED: https://api.unsplash.com")
        }
        return url
    }
    
    var endpoint: Endpoint {
        switch self {
        case .getMe:
            return .get(path: "/me")
        case .updateMe:
            return .put(path: "/me")
        case let .userProfile(param):
            return .get(path: "/users/\(param.username)")
        case let .userPortfolio(username):
            return .get(path: "/users/\(username)/portfolio")
        case let .userPhotos(param):
            return .get(path: "/users/\(param.username)/photos")
        case let .userLikedPhotos(param):
            return .get(path: "/users/\(param.username)/likes")
        case let .userCollections(param):
            return .get(path: "/users/\(param.username)/collections")
        case let .userStatistics(param):
            return .get(path: "/users/\(param.username)/statistics")
        case .photos:
            return .get(path: "/photos")
        case let .photo(param):
            return .get(path: "/photos/\(param.id)")
        case .randomPhoto:
            return .get(path: "/photos/random")
        case let .photoStatistics(param):
            return .get(path: "/photos/\(param.id)/statistics")
        case let .photoDownloadLink(id):
            return .get(path: "/photos/\(id)/download")
        case let .likePhoto(id):
            return .post(path: "/photos/\(id)/like")
        case let .unlikePhoto(id):
            return .delete(path: "/photos/\(id)/like")
        case .searchPhotos:
            return .get(path: "/search/photos")
        case .searchCollections:
            return .get(path: "/search/collections")
        case .searchUsers:
            return .get(path: "/search/users")
        case .collections:
            return .get(path: "/collections")
        case .createCollection:
            return .post(path: "/collections")
        case .featuredCollections:
            return .get(path: "/collections/featured")
        case let .collection(id):
            return .get(path: "/collections/\(id)")
        case let .collectionPhotos(params):
            return .get(path: "/collections/\(params.id)/photos")
        case let .relatedCollections(id):
            return .get(path: "/collections/\(id)/related")
        case let .updateCollection(params):
            return .put(path: "/collections\(params.id)")
        case let .deleteCollection(id):
            return .delete(path: "/collections/\(id)")
        case let .addPhotoToCollection(params):
            return .post(path: "/collections/\(params.collectionID)/add")
        case let .removePhotoFromCollection(params):
            return .delete(path: "/collections/\(params.collectionID)/remove")
        }
    }
