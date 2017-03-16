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
    
    public static func uploadPhoto(_ image: UIImage, completionHandler completion: @escaping Completion) {
        let mainCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        DispatchQueue.global().async {
            do {
                let data = try ImageService.convert(image)
                let imageBodyPart = BodyPart(data: data, name: "upload", fileName: "upload.jpg", mimeType: "image/jpeg")
                NetworkService.shared.uploadData(for: .upload(imageBodyPart)) { result in
                    switch result {
                    case .failure(let error):
                        mainCompletion(.failure(error))
                    case .success(let json):
                        mainCompletion(.success(json))
                    }
                }
            }
            catch {
                mainCompletion(.failure(error))
            }
        }
    }
}
