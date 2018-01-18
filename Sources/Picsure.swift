//
//  Picsure.swift
//  Picsure
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import UIKit

public typealias JSON = [String: Any]
public typealias Completion = (Result<JSON>) -> Void

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public final class Picsure {

    /// Configures framework authorization.
    ///
    /// - Note: Call this function before photo uploading.
    ///
    /// - Parameters:
    ///   - apiKey: your API key for Picsure service.
    public static func configure(withApiKey apiKey: String) {
        NetworkService.shared.token = apiKey
    }

    /// Configures language for response.
    ///
    /// - Note: Call this function before photo uploading.
    ///
    /// - Parameters:
    ///   - language: language identifier.
    public static func configure(language: String) {
        NetworkService.shared.language = language
    }

    /// Uploads the photo and starts an image recognition process 🚀.
    ///
    /// - Note: The recognition takes from several seconds up to one minute.
    ///
    /// - Parameters:
    ///   - image: The image for recognition.
    ///   - completion: Returns server response or internal SDK errors. Check all error types in `PicsureErrors`.
    public static func upload(_ image: UIImage, completion: @escaping Completion) {
        let mainCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        DispatchQueue.global().async {
            do {
                let data = try ImageService.convert(image)
                let imageBodyPart = BodyPart(data: data)
                let exif: Parameters = [:]
                NetworkService.shared.uploadData(for: .upload(imageBodyPart, exif: exif)) { result in
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
