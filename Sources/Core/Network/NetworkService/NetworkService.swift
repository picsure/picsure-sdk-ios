//
//  NetworkService.swift
//  Picsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

fileprivate typealias TaskHandler = (Data?, URLResponse?, Error?) -> Void
typealias ParsedTaskHandler = (_ json: JSON?, _ statusCode: Int?, _ error: Error?) -> Void

final class NetworkService {

    private enum Constants {
        static let host = URL(string: "https://api.picsure.ai")!
    }
    
    private let session = URLSession(configuration: .default)
    
    static let shared = NetworkService()
    
    var token: String?
    var language: String = "en"
    
    private init() {}
    
    /// Upload the image and returns recognition information.
    ///
    /// - Parameters:
    ///   - endpoint: The upload endpoint with image data.
    /// - completion: The completion with recognition information or error if it occurred.
    func uploadData(for endpoint: ImageUploadEndpoint, completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(PicsureErrors.TokenErrors.missingToken))
            return
        }
        
        let request = RequestFactory.makeRequest(host: Constants.host, endpoint: endpoint, token: token)
        let task = session.dataTask(with: request, completionHandler: taskHandler { json, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let json = json {
                guard let imageID = json["image_id"] as? String else {
                    completion(.failure(PicsureErrors.NetworkErrors.cannotParseResponse))
                    return
                }
                self.lookup(imageID: imageID, completion: completion)
            }
        })
        task.resume()
    }

    @discardableResult
    private func dataTask(for endpoint: RequestEndpoint, completion: @escaping ParsedTaskHandler) -> URLSessionDataTask? {
        guard let token = token else {
            return nil
        }

        let request = RequestFactory.makeRequest(host: Constants.host, endpoint: endpoint, token: token, language: language)
        let task = session.dataTask(with: request, completionHandler: taskHandler(with: completion))
        task.resume()
        return task
    }
    
    private func taskHandler(with completion: @escaping ParsedTaskHandler) -> TaskHandler {
        return { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let code = statusCode, code == 401 {
                completion(nil, statusCode, PicsureErrors.TokenErrors.invalidToken)
                return
            }
            
            if let error = error {
                completion(nil, statusCode, error)
                return
            }
            
            guard let unwrappedData = data else {
                completion(nil, statusCode, PicsureErrors.NetworkErrors.emptyServerData)
                return
            }
            guard let json = ResponseParser.parseJSON(from: unwrappedData) else {
                completion(nil, statusCode, PicsureErrors.NetworkErrors.cannotParseResponse)
                return
            }
            completion(json, statusCode, nil)
        }
    }

    private func lookup(imageID: String, completion: @escaping Completion) {
        let lookupTask = dataTask(for: LookupEndpoint.lookup(imageID)) { json, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let json = json {
                completion(.success(json))
            }
        }
        lookupTask?.resume()
    }
}
