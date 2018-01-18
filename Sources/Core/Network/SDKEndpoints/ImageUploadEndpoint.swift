//
//  ImageUploadEndpoint.swift
//  Picsure
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

enum ImageUploadEndpoint: UploadEndpoint {
    
    case upload(BodyPart, exif: Parameters?)
    
    var path: String {
        return "1/upload"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var bodyPart: BodyPart {
        switch self {
        case .upload(let bodyPart, _): return bodyPart
        }
    }

    var parameters: Parameters? {
        switch self {
        case .upload(_, let exif):
            if let exif = exif {
                return ["exif": exif]
            }
            return nil
        }
    }
}
