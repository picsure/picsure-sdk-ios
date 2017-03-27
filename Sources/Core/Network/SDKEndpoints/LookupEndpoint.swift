//
//  LookupEndpoint.swift
//  Snapsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

enum LookupEndpoint: RequestEndpoint {
    
    case lookup(Int)
    
    var method: HTTPMethod {
        switch self {
        case .lookup: return .get
        }
    }
    
    var path: String {
        switch self {
        case .lookup(let identifier): return "lookup/\(identifier)"
        }
    }
}
