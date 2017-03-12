//
//  NetworkService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public final class NetworkService {
    
    private let session: URLSession
    
    var baseURLString = "https://node-2.snapsure.de/"
    var token = "developer-a3a2e467-999e-4d57-abc6-b0ed90f1c48f"
    
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
    
    func test(for endpoint: ImageUploadEndpoint) {
//        session.uploadTask(with: request, from: <#T##Data?#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
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
    
    public func lookupRequest() {
        let request = self.request(for: LookupEndpoint.lookup(21))
        
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
    
    func request(for endpoint: Endpoint) -> URLRequest {
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
    
    func request(for endpoint: ImageUploadEndpoint) -> URLRequest {
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
