//
//  ImageUploadEndpoint.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

enum ImageUploadEndpoint: UploadEndpoint {
    
    case upload([ImageBodyPart])
    
    var method: HTTPMethod {
        switch self {
        case .upload: return .get
        }
    }
    
    var path: String {
        switch self {
        case .upload: return "images"
        }
    }
    
    var headers: [RequestHeaders] {
        switch self {
        case .upload: return [.multipartData]
        }
    }
    
    var bodyParts: [ImageBodyPart] {
        switch self {
        case .upload(let bodyParts): return bodyParts
        }
    }
}
