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
fileprivate typealias Test = (Data?, URLResponse?, Error?) -> Swift.Void

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

        let task = session.dataTask(with: request) { data, response, error in
            //TODO: check reachable status
            
            let httpResponse = response as! HTTPURLResponse
            //TODO: check status code
            
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
            
            let id = json["id"]
            print(id ?? "no id in response")
            completion(.success(json))
        }
        task.resume()
    }
    
    func checkImage(for endpoint: RequestEndpoint, completion: @escaping Completion) {
        guard let token = token else {
            completion(.failure(SnapsureErrors.TokenErrors.missingToken))
            return
        }
        let request = RequestFactory.request(for: endpoint, withToken: token)
        
        let task = session.dataTask(with: request, completionHandler: taskHandler(with: completion))
        task.resume()
    }
    
    private func taskHandler(with completion: @escaping Completion) -> Test {
        return { data, _, error -> Void in
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
    }
}
