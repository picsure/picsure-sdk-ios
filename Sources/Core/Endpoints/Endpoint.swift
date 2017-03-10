//
//  BaseEndpoint.swift
//  VanHaren
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2016 Rosberry. All rights reserved.
//

protocol Endpoint {
    
    var baseURL: String { get }
    var path: String { get }
    var headers: [RequestHeaders] { get }
    var parameters: Parameters { get }
    var requiresAuthorizationHeaders: Bool { get }
}

extension Endpoint {
    
    var baseURL: String {
        return "http://52.15.162.59/omegle/"
    }
    
    var headers: [RequestHeaders] {
        switch self {
        default: return []
        }
    }
    
    var requiresAuthorizationHeaders: Bool {
        return true
    }
}
