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
    
    public static func configure(withApiKey apiKey: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
    }
    
    static func uploadPhoto(_ image: Image, completionHandler completion:((Result<JSON>) -> Void)) {
        
//        let data: Data!
//        NetworkService.shared.uploadData(data) { 
//            
//        }
    }
}
