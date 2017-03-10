//
//  RequestEndpoint.swift
//  VanHaren
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2016 Rosberry. All rights reserved.
//

protocol RequestEndpoint: Endpoint {
    
    var method: HTTPMethod { get }
}
