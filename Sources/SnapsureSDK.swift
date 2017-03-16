//
//  SnapsureSDK.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public final class SnapsureSDK {

    //TODO: Only for testing
    private static var lookupService: LookupService!
    
    public static func configure(withApiKey apiKey: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
    }
    
    public static func uploadPhoto(_ image: UIImage, completionHandler completion: @escaping Completion) {
        DispatchQueue.global().async {
            do {
                let data = try ImageService.convert(image)
                let imageBodyPart = BodyPart(data: data, name: "upload", fileName: "saw.jpg", mimeType: "image/jpeg")
                NetworkService.shared.uploadData(for: .upload(imageBodyPart)) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let json):
                        let id = json["id"] as! Int
                        print(id)
                        startLookup(withID: id, completion: completion)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private static func startLookup(withID id: Int, completion: @escaping Completion) {
        lookupService = LookupService(id: id)
        lookupService.completion = completion
        lookupService.start()
    }
}
