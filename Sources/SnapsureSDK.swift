//
//  SnapsureSDK.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

//TODO: macos
typealias Image = UIImage

typealias JSON = Dictionary<String, Any>

enum Result<T> {
    case success(T)
    case failure(Error)
}

public final class SnapsureSDK {
    
    static func configure(withApiKey apiKey: String, forBaseURLString URLString: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
        networkService.baseURLString = URLString
    }
    
    static func uploadPhoto(_ image: Image, completionHandler completion:((Result<JSON>) -> Void)) {
        
    }
}
