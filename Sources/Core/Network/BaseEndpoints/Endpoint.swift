//
//  BaseEndpoint.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

typealias Parameters = [String: Any]

protocol Endpoint {
    
    var baseURL: String { get }
    var path: String { get }
    var headers: [RequestHeaders] { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    
    var baseURL: String {
        return "https://node-2.snapsure.de/"
    }
    
    var headers: [RequestHeaders] {
        return []
    }
    
    var parameters: Parameters {
        return [:]
    }
}
