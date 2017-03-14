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
    
    var token: String?
    
    static var shared = NetworkService()
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func uploadData(for endpoint: ImageUploadEndpoint, completionHandler completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        
        let request = RequestFactory.request(for: endpoint, withToken: token)
        let data = endpoint.bodyPart.data
        
        let task = session.uploadTask(with: request, from: data) { data, _, error in
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

    func checkImage(for endpoint: Endpoint, completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        let request = RequestFactory.request(for: endpoint, withToken: token)
        
        let task = session.dataTask(with: request) { data, _, error -> Void in
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
}
