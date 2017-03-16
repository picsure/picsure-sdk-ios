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
 
        postBody.append("--\(boundary)".return.dataWithUTF8Encoding)
        postBody.append("Content-Disposition: form-data; name=\"\(bodyPart.name)\"; filename=\"\(bodyPart.fileName)\"".return.dataWithUTF8Encoding)
        postBody.append("Content-Type: \(bodyPart.mimeType)".return.return.dataWithUTF8Encoding)
        postBody.append(bodyPart.data)
        postBody.append("".return.dataWithUTF8Encoding)
        postBody.append("--\(boundary)--".return.dataWithUTF8Encoding)
        
        request.httpBody = postBody

        var headers = endpoint.headers
        headers.append(RequestHeaders.contentLength(postBody))
        headers.append(RequestHeaders.authorization(token))
        headers.append(RequestHeaders.multipartData(boundary))
        request.addHeaders(headers)
        
        return request
    }
}

fileprivate extension URLRequest {
    
    init(endpoint: Endpoint) {
        let url = URL(string: endpoint.baseURL)!.appendingPathComponent(endpoint.path)

        self.init(url: url)
        httpMethod = endpoint.method.rawValue
    }
    
    mutating func addHeaders(_ headers: [RequestHeaders]) {
        headers.forEach {
            addValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

fileprivate extension String {
    
    var `return`: String {
        return self + "\r\n"
    }
    
    var dataWithUTF8Encoding: Data {
        return data(using: String.Encoding.utf8)!
    }
}
