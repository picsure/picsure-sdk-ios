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

fileprivate typealias TaskHandler = (Data?, URLResponse?, Error?) -> Void

typealias ParsedTaskHandler = (JSON?, Int, Error?) -> Void

public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class NetworkService {

    private var lookupServices = [Int: LookupService]()
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

        let task = session.dataTask(with: request, completionHandler: taskHandler { [weak self] json, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let json = json {
                let id = json["id"] as! Int
                let service = LookupService(id: id) { [weak self] result in
                    self?.lookupServices[id] = nil
                    completion(result)
                }
                service.start()
                self?.lookupServices[id] = service
            }
        })
        task.resume()
    }
    
    @discardableResult
    func checkImageTask(for endpoint: RequestEndpoint, completion: @escaping ParsedTaskHandler) -> URLSessionDataTask? {
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
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if let error = error {
                //TODO: Send SKD error
                completion(nil, statusCode, error)
                return
            }
            
            if statusCode > 200, statusCode != 404 {
                //TODO: custom error
                completion(nil, statusCode, nil)
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
