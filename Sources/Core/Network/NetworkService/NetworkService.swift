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
        let data = endpoint.bodyPart.data
        
        let task = session.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                completion(.failure(SnapsureErrors.TokenErrors.missingToken))
                return
            }
            
            let id = 21
            let timer = RequestTimer.default

            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 401 {
                completion(.failure(SnapsureErrors.TokenErrors.missingToken))
                return
            }
            
            guard let data = data else {
                completion(.failure(SnapsureErrors.NetworkErrors.emptyServerData))
                return
            }
            
            do {
                guard let json = (try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : AnyObject]) else {
                    completion(.failure(SnapsureErrors.NetworkErrors.cannotParseResponse))
                    return
                }
                print(json)
            }
            catch {
                completion(.failure(SnapsureErrors.NetworkErrors.cannotParseResponse))
            }
            
            
            
            timer.timeIsOverHandler = {
                // Stop request
                // completion()
            }
            
            timer.nextIntervalHandler = { _ in
                // Do request and in completion - fire timer.
                // timer.continue()
            }
            
            // In request completion get id and fire timer.
            // timer.start()
            
            
//            checkImage(for: LookupEndpoint.lookup(id)) { result in
//                
//            }
        }
        task.resume()
    }
    
    func checkImage(for endpoint: Endpoint, completion: @escaping Completion) {
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
