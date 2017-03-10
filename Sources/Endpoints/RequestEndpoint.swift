//
//  RequestEndpoint.swift
//  VanHaren
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Alamofire

typealias Parameters = [String: Any]

protocol RequestEndpoint: Endpoint {
    
    var method: HTTPMethod { get }
    var parameterEncoding: ParameterEncoding { get }
}
