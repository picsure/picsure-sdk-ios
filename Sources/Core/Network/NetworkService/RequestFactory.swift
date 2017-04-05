//
//  RequestFactory.swift
//  Snapsure
//
//  Created by Artem Novichkov on 12/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class RequestFactory {
    
    /// Configures request with URL, method and headers from the request endpoint. Returns nil if host is invalid.
    ///
    /// - Parameters:
    ///   - host: The host for request configiration.
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    ///
    /// - Returns: Configurated request.
    static func request(forHost host: String, endpoint: RequestEndpoint, withToken token: String) -> URLRequest? {
        guard var request = URLRequest(host: host, endpoint: endpoint) else {
            return nil
        }
        
        var headers = endpoint.headers
        headers.append(RequestHeaders.authorization(token: token))
        headers.append(RequestHeaders.accept)
        request.addHeaders(headers)
        
        return request
    }
    
    /// Configures request with URL, method, headers and bodypart from the upload endpoint. Returns nil if host is invalid.
    ///
    /// - Parameters:
    ///   - host: The host for request configiration.
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    ///
    /// - Returns: Configurated request.
    static func request(forHost host: String, endpoint: UploadEndpoint, withToken token: String) -> URLRequest? {
        guard var request = URLRequest(host: host, endpoint: endpoint) else {
            return nil
        }
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
        headers.append(RequestHeaders.contentLength(data: postBody))
        headers.append(RequestHeaders.authorization(token: token))
        headers.append(RequestHeaders.multipartData(boundary: boundary))
        request.addHeaders(headers)
        
        return request
    }
}

fileprivate extension URLRequest {
    
    /// Initializes the request with URL and HTTP method from the endpoint. Returns nil if host is invalid.
    ///
    /// - Parameter endpoint: The endpoint for request configuration.
    init?(host: String, endpoint: Endpoint) {
        guard let url = URL(string: host)?.appendingPathComponent(endpoint.path) else {
            return nil
        }

        self.init(url: url)
        httpMethod = endpoint.method.rawValue
    }
    
    /// Adds the headers.
    ///
    /// - Parameter headers: The headers for adding.
    mutating func addHeaders(_ headers: [RequestHeaders]) {
        headers.forEach {
            addValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

fileprivate extension String {
    
    /// Returns string with carriage returns addings.
    var `return`: String {
        return self + "\r\n"
    }
    
    /// Returns data with UTF8 Encoding.
    var dataWithUTF8Encoding: Data {
        return data(using: String.Encoding.utf8)!
    }
}
