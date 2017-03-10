//
//  RequestHeaders.swift
//  VanHaren
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2016 Rosberry. All rights reserved.
//

enum RequestHeaders {
    
    case authorization(String)
    
    var key: String {
        switch self {
        case .authorization: return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .authorization(let token): return "Bearer \(token)"
        }
    }
}
