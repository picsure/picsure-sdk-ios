//
//  RequestEndpoint.swift
//  Picsure
//
//  Created by Nikita Ermolenko on 16/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

typealias Parameters = [String: Any]

protocol RequestEndpoint: Endpoint {
    
    var parameters: Parameters? { get }
}

extension RequestEndpoint {
    
    var parameters: Parameters? {
        return nil
    }
}
