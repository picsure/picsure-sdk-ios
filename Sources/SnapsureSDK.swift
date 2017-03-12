//
//  SnapsureSDK.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public final class SnapsureSDK {
    
    public static func configure(withApiKey apiKey: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
    }
    
    public static func uploadPhoto(_ image: UIImage, completionHandler completion:((Result<JSON>) -> Void)) {
        do {
            let data = try ImageService.convert(image)
            let imageBodyPart = ImageBodyPart(data: data, name: "1", fileName: "1.jpg", mimeType: "image/jpg")
            try NetworkService.shared.test(for: .upload(imageBodyPart))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    public static func lookupTest() {
        NetworkService.shared.lookupRequest(for: LookupEndpoint.lookup(21)) { (result: Result<JSON>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let json):
                print(json)
            }
        }
    }
}
