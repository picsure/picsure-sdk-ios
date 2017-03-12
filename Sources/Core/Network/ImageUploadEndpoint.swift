//
//  ImageUploadEndpoint.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

enum ImageUploadEndpoint: UploadEndpoint {
    
    case upload(ImageBodyPart)
    
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
    
    var bodyPart: ImageBodyPart {
        switch self {
        case .upload(let bodyPart): return bodyPart
        }
    }
}
