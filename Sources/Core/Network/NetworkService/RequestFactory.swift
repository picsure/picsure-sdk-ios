//
//  RequestFactory.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 12/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class RequestFactory {
    
    /// Configures request with URL, method and headers
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    /// - Returns: Configurated request.
    static func request(for endpoint: Endpoint, withToken token: String) -> URLRequest {
        let path = endpoint.baseURL + endpoint.path
        let url = URL(string: path)!
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        var headers = endpoint.headers
        headers.append(RequestHeaders.authorization(token))
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
