//
//  LookupEndpoint.swift
//  Picsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

enum LookupEndpoint: RequestEndpoint {
    
    case lookup(String)
    
    var method: HTTPMethod {
        switch self {
        case .lookup: return .get
        }
    }
    
    var path: String {
        switch self {
        case .lookup(let imageToken): return "3/lookup/\(imageToken)"
        }
    }
}
