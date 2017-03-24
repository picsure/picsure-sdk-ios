//
//  BaseEndpoint.swift
//  Snapsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

protocol Endpoint {

    var baseURL: String { get }
    var path: String { get }
    var headers: [RequestHeaders] { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    
    var baseURL: String {
        return "http://api.snapsure.de"
    }
    
    var headers: [RequestHeaders] {
        return []
    }
}
