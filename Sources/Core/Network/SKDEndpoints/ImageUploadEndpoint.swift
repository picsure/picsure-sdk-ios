//
//  ImageUploadEndpoint.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

enum ImageUploadEndpoint: UploadEndpoint {
    
    case upload(BodyPart)
    
    var path: String {
        return "images/"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var bodyPart: BodyPart {
        switch self {
        case .upload(let bodyPart): return bodyPart
        }
    }
}
