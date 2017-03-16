//
//  RequestEndpoint.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 16/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
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
