//
//  RequestFactory.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 12/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class RequestFactory {
    
    /// Configures request with URL, method and headers.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint for request configiration.
    ///   - token: The token string for authorization header.
    ///
    /// - Returns: Configurated request.
    static func request(for endpoint: RequestEndpoint, withToken token: String) -> URLRequest {
        var request = URLRequest(endpoint: endpoint)
        
        var headers = endpoint.headers
        headers.append(RequestHeaders.authorization(token))
        request.addHeaders(headers)
        
        return request
    }
    
    static func request(for endpoint: UploadEndpoint, withToken token: String) -> URLRequest {
        var request = URLRequest(endpoint: endpoint)

        let bodyPart = endpoint.bodyPart
        let boundary = UUID().uuidString
        var postBody = Data()
 
        postBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        postBody.append("Content-Disposition: form-data; name=\"\(bodyPart.name)\"; filename=\"\(bodyPart.fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        postBody.append("Content-Type: \(bodyPart.mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
        postBody.append(bodyPart.data)
        postBody.append("\r\n".data(using: String.Encoding.utf8)!)
        postBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = postBody

        var headers = endpoint.headers
        headers.append(RequestHeaders.contentLenght(postBody))
        headers.append(RequestHeaders.authorization(token))
        headers.append(RequestHeaders.multipartData(boundary))
        request.addHeaders(headers)
        
        return request
    }
}

fileprivate extension URLRequest {
    
    init(endpoint: Endpoint) {
        let path = endpoint.baseURL + endpoint.path
        let url = URL(string: path)!

        self.init(url: url)
        httpMethod = endpoint.method.rawValue
    }
    
    mutating func addHeaders(_ headers: [RequestHeaders]) {
        headers.forEach {
            addValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}
