//
//  UnSplashAuthManager.swift
//  Splash
//
//  Created by Running Raccoon on 2020/07/30.
//  Copyright © 2020 Running Raccoon. All rights reserved.
//

import Foundation
import TinyNetworking

protocol UnsplashSessionListener {
    func didReceiveRedirect(code: String)
}

enum UnsplashAuthorization: Resource {
    
    case accessToken(with: String)
    
    var baseURL: URL {
        guard let url = URL(string: "https://unsplash.com") else {
            fatalError("failed")
        }
        
        return url
    }
    
    var endpoint: Endpoint {
        return .post(path: "/oauth/token")
    }
    
    var task: Task {
        switch self {
        case let .accessToken(with: code):
            var params: [String:Any] = [:]
            
            params["grant_type"] = "authorization_code"
            params["client_id"] = Constants.Splash.clientID
            params["client_secret"] = Constants.Splash.clientSecret
            params["redirect_uri"] = Constants.Splash.redirectURL
            params["code"] = code
            
            return .requestWithParameters(params, encoding: URLEncoding())
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}

class UnSplashAuthManager {
    var delegate: UnsplashSessionListener!
    
    static var shared: UnSplashAuthManager {
        return UnSplashAuthManager(clientID: Constants.Splash.clientID, clientSecret: Constants.Splash.clientSecret, scopes: Scope.allCases)
    }
    
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [Scope]
    private let unsplash: TinyNetworking<UnsplashAuthorization>
    
    public var accessToken: String? {
        return UserDefaults.standard.string(forKey: clientID)
    }
    
    public func clearAccessToken() {
        return UserDefaults.standard.removeObject(forKey: clientID)
    }
    
    public var authURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.Splash.host
        components.path = "/oauth/authorize"
        
        var params: [String:String] = [:]
        params["client_id"] = Constants.Splash.clientID
        params["redirect_uri"] = redirectURL.absoluteString
        params["response_type"] = "code"
        params["scope"] = scopes.map { $0.rawValue }.joined(separator: "+")
        
        let url = components.url?.appendingQueryParameters(params)
        
        return url!
    }
    
    init(clientID: String, clientSecret: String, scopes: [Scope] = [Scope.pub], unsplash: TinyNetworking<UnsplashAuthorization> = TinyNetworking<UnsplashAuthorization>()) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.redirectURL = URL(string: Constants.Splash.redirectURL)!
        self.unsplash = unsplash
    }
    
    public func accessToken(with code: String, completion: @escaping (Result<Void, Splash.Error>) -> ()) {
        unsplash.request(resource: .accessToken(with: code)) { [unowned self] result in
            let result = result
                .map { response -> Void in
                    if let accessTokenObject = try? response.map(to: UserAuthToken.self) {
                        UserDefaults.standard.set(accessTokenObject.accessToken, forKey: self.clientID)
                    }
            }.mapError { error -> Splash.Error in
                return .other(message: error.localizedDescription)
            }
            completion(result)
        }
    }
    
    private func extractCode(from url: URL) -> String? {
        return url.value(for: "code")
    }
    
    private func extractErrorDescription(from data: Data) -> String? {
        let error = try? JSONDecoder().decode(AuthError.self, from: data)
        return error?.errorDescription
    }
    
    
    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url) else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    private func accessTokenURL(with code: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.Splash.host
        components.path = "/oauth/token"
        
        var params: [String:String] = [:]
        params["grant_type"] = "authorization_code"
        params["client_id"] = clientID
        params["client_secret"] = clientSecret
        params["redirect_uri"] = redirectURL.absoluteString
        params["code"] = code
        
        let url = components.url?.appendingQueryParameters(params)
        
        return url!
    }
}
