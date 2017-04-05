//
//  Snapsure.swift
//  Snapsure
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

public typealias JSON = [String: Any]
public typealias Completion = (Result<JSON>) -> Void

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public final class Snapsure {

    /// Configures framework authorization.
    ///
    /// - Note: Call this function before photo uploading.
    ///
    /// - Parameters:
    ///   - apiKey: your API key for Snapsure service.
    ///   - host: your host for Snapsure service.
    public static func configure(withApiKey apiKey: String, host: String) {
        let networkService = NetworkService.shared
        networkService.token = apiKey
        networkService.host = host
    }

    /// Uploads the photo and starts an image recognition process 🚀.
    ///
    /// - Note: The recognition takes from several seconds up to one minute.
    ///
    /// - Parameters:
    ///   - image: The image for recognition.
    ///   - completion: Returns server response or internal SDK errors. Check all error types in `SnapsureErrors`.
    public static func uploadPhoto(_ image: UIImage, completion: @escaping Completion) {
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
