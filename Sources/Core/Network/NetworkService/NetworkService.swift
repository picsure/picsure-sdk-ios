//
//  NetworkService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

fileprivate typealias TaskHandler = (Data?, URLResponse?, Error?) -> Void
typealias ParsedTaskHandler = (_ json: JSON?, _ statusCode: Int?, _ error: Error?) -> Void

final class NetworkService {

    private let session = URLSession(configuration: .default)
    
    static let shared = NetworkService()
    
    var token: String?
    
    private init() {}
    
    /// Upload the image and returns recognition information.
    ///
    /// - Parameters:
    ///   - endpoint: The upload endpoint with image data.
    /// - completion: The completion with recognition information or error if it occurred.
    func uploadData(for endpoint: ImageUploadEndpoint, completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        
        let request = RequestFactory.request(for: endpoint, withToken: token)
        let task = session.dataTask(with: request, completionHandler: taskHandler { json, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let json = json {
                LookupService.shared.addLookupTask(for: json, completion: completion)
            }
        })
        task.resume()
    }
    
    /// Returns a task configured with request endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The request endpoint. 
    ///   - completion: The completion with optional parameters: json, status code and error.
    /// - Returns: Task configured with request endpoint.
    @discardableResult
    func dataTask(for endpoint: RequestEndpoint, completion: @escaping ParsedTaskHandler) -> URLSessionDataTask? {
        guard let token = token else {
            return nil
        }
        let request = RequestFactory.request(for: endpoint, withToken: token)
        let task = session.dataTask(with: request, completionHandler: taskHandler(with: completion))
        task.resume()
        return task
    }

    private func taskHandler(with completion: @escaping ParsedTaskHandler) -> TaskHandler {
        return { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                completion(nil, statusCode, error)
                return
            }

            guard let unwrappedData = data else {
                completion(nil, statusCode, SnapsureErrors.NetworkErrors.emptyServerData)
                return
            }
            guard let json = ResponseParser.parseJSON(from: unwrappedData) else {
                completion(nil, statusCode, SnapsureErrors.NetworkErrors.cannotParseResponse)
                return
            }
            completion(json, statusCode, nil)
        }
    }
}
