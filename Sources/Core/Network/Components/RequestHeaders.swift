//
//  RequestHeaders.swift
//  Picsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

enum RequestHeaders {
    
    case authorization(token: String)
    case accept
    case multipartData(boundary: String)
    case contentLength(data: Data)
    
    var key: String {
        switch self {
        case .authorization: return "Authorization"
        case .accept: return "Accept"
        case .multipartData: return "Content-Type"
        case .contentLength: return "Content-Length"
        }
    }
    
    var value: String {
        switch self {
        case .authorization(let token): return "Bearer \(token)"
        case .accept: return "application/json"
        case .multipartData(let boundary): return "multipart/form-data; boundary=\(boundary)"
        case .contentLength(let body): return String(body.count)
        }
    }
}
