//
//  RequestFactory.swift
//  Picsure
//
//  Created by Artem Novichkov on 12/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

final class RequestFactory {
    
    /// Configures request with URL, method and headers from the request endpoint.
    ///
    /// - Parameters:
    ///   - host: The host for request configiration.
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    ///   - language: The language identifier for language header.
    ///
    /// - Returns: Configurated request.
    static func makeRequest(host: URL, endpoint: RequestEndpoint, token: String, language: String) -> URLRequest {
        var request = URLRequest(host: host, endpoint: endpoint)
        
        var headers = endpoint.headers
        headers.append(.authorization(token: token))
        headers.append(.language(language))
        headers.append(.accept)
        request.add(headers)
        
        return request
    }
    
    /// Configures request with URL, method, headers and bodypart from the upload endpoint.
    ///
    /// - Parameters:
    ///   - host: The host for request configiration.
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    ///
    /// - Returns: Configurated request.
    static func makeRequest(host: URL, endpoint: UploadEndpoint, token: String) -> URLRequest {
        var request = URLRequest(host: host, endpoint: endpoint)
        let bodyPart = endpoint.bodyPart
        let boundary = UUID().uuidString
        var postBody = Data()
 
        postBody.append("--\(boundary)".return.dataWithUTF8Encoding)
        postBody.append("Content-Disposition: form-data; name=\"\(bodyPart.name)\"; filename=\"\(bodyPart.fileName)\"".return.dataWithUTF8Encoding)
        postBody.append("Content-Type: \(bodyPart.mimeType)".return.return.dataWithUTF8Encoding)
        postBody.append(bodyPart.data)
        postBody.append("".return.dataWithUTF8Encoding)
        postBody.append("--\(boundary)--".return.dataWithUTF8Encoding)
        
        request.httpBody = postBody

        var headers = endpoint.headers
        headers.append(.contentLength(data: postBody))
        headers.append(.authorization(token: token))
        headers.append(.multipartData(boundary: boundary))
        request.add(headers)
        
        return request
    }
}

private extension URLRequest {
    
    /// Initializes the request with URL and HTTP method from the endpoint.
    ///
    /// - Parameter endpoint: The endpoint for request configuration.
    init(host: URL, endpoint: Endpoint) {
        self.init(url: host.appendingPathComponent(endpoint.path))
        httpMethod = endpoint.method.rawValue
    }
    
    /// Adds the headers.
    ///
    /// - Parameter headers: The headers for adding.
    mutating func add(_ headers: [RequestHeaders]) {
        headers.forEach {
            addValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

private extension String {
    
    /// Returns string with carriage returns addings.
    var `return`: String {
        return self + "\r\n"
    }
    
    /// Returns data with UTF8 Encoding.
    var dataWithUTF8Encoding: Data {
        return data(using: .utf8)!
    }
}
