//
//  NetworkService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]
public typealias Completion = (Result<JSON>) -> Void

public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class NetworkService {
    
    private let session: URLSession
    private var baseURLString = "https://node-2.snapsure.de/"
    
    var token: String?
    
    static var shared = NetworkService()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    //TODO: Don't forget about main thread / background. Don't do it in the main thread.
    
    func uploadData(for endpoint: ImageUploadEndpoint, completionHandler completion: @escaping Completion) {
//        let timer = RequestTimer.default
//        timer.timeIsOverHandler = {
//            // Stop request
//            // completion()
//        }
//        
//        timer.nextIntervalHandler = { _ in
//            // Do request and in completion - fire timer.
//            // timer.continue()
//        }
//        
//        // In request completion get id and fire timer.
//        // timer.start()
        
        
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        
        let request = RequestFactory.request(for: endpoint, withToken: token)
        let data = endpoint.bodyPart.data
        
        let task = session.uploadTask(with: request, from: data) { data, response, error in
            //map to custom error
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let unwrappedData = data else {
                completion(.failure(SnapsureErrors.NetworkErrors.emptyServerData))
                return
            }
            guard let json = ResponseParser.parseJSON(from: unwrappedData) else {
                completion(.failure(SnapsureErrors.NetworkErrors.cannotParseResponse))
                return
            }

            completion(.success(json))
        }
        task.resume()
    }

    func lookupRequest(for endpoint: Endpoint, completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        let request = RequestFactory.request(for: endpoint, withToken: token)
        
        let task = session.dataTask(with: request) { data, response, error -> Void in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let unwrappedData = data else {
                completion(.failure(SnapsureErrors.NetworkErrors.emptyServerData))
                return
            }
            guard let json = ResponseParser.parseJSON(from: unwrappedData) else {
                completion(.failure(SnapsureErrors.NetworkErrors.cannotParseResponse))
                return
            }
            completion(.success(json))
        }
        task.resume()
    }
    
    func addToken(for request: inout URLRequest) {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
