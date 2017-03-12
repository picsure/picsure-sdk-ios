//
//  NetworkService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

final class NetworkService {
    
    private let session: URLSession
    
    var baseURLString = "https://node-2.snapsure.de/"
    var token: String?
    
    static var shared = NetworkService()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    
    //TODO: Don't forget about main thread / background. Don't do it in the main thread.
    func uploadData(_ data: Data, completionHandler completion:@escaping () -> Void) {
        let timer = RequestTimer.default
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
    }
    
    func test(for endpoint: ImageUploadEndpoint) throws {
        guard let token = token else {
            throw SnapsureErrors.TokenErrors.missingToken
        }
        let request = RequestFactory.request(for: endpoint, token: token)
        let data = endpoint.bodyPart.data
        session.uploadTask(with: request, from: data) { data, response, error in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription)
            }
        }
    }
    
    
    func sendRequest1() {
        let url = URL(string: "\(baseURLString)images/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Headers
        
        addToken(for: &request)
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func lookupRequest(for endpoint: Endpoint) throws {
        guard let token = token else {
            throw SnapsureErrors.TokenErrors.missingToken
        }
        let request = RequestFactory.request(for: endpoint, token: token)
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let response = response {
                print(response)
            }
            if error == nil {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let d = data {
                    let json = self.parseJSON(from: d)
                    DispatchQueue.main.async {
                        print(json ?? "no")
                    }
                }
                else {
                    print("no data")
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func addToken(for request: inout URLRequest) {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func parseJSON(from data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
            return json
        }
        catch {
            return nil
        }
    }
}

class RequestFactory {
    
    static func request(for endpoint: Endpoint, token: String) -> URLRequest {
        let path = endpoint.baseURL + endpoint.path
        let url = URL(string: path)!
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        var headers = endpoint.headers
        headers.append(RequestHeaders.authorization(token))
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
}
