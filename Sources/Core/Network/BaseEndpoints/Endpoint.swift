//
//  BaseEndpoint.swift
//  Picsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

protocol Endpoint {

    var path: String { get }
    var headers: [RequestHeaders] { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    
    var headers: [RequestHeaders] {
        return []
    }
}
