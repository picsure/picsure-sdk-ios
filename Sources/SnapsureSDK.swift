//
//  SnapsureSDK.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public final class SnapsureSDK {

    /// Configures framework authorization. Call this method within your App Delegate's `application:didFinishLaunchingWithOptions:` and provide API key.
    ///
    /// - Parameter apiKey: your API key for Snapsure service.
    public static func configure(withApiKey apiKey: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
    }
    
    /// Resizes selected photo if needed, uploads to Snapsure and waits for server response. Than checks a status of uploaded image periodically and returns a response. If server can't process the image during 60 seconds, returns timeout error.
    ///
    /// - Parameters:
    ///   - image: The image for processing
    ///   - completion: Returns server response or internal SDK errors. Check all error types in `SnapsureErrors`.
    public static func uploadPhoto(_ image: UIImage, completionHandler completion: @escaping Completion) {
        let mainCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        DispatchQueue.global().async {
            do {
                let data = try ImageService.convert(image)
                let imageBodyPart = BodyPart(data: data)
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
