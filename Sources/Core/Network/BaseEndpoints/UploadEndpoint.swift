//
//  UploadEndpoint.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

protocol UploadEndpoint: Endpoint {
    
    var bodyPart: ImageBodyPart { get }
}
