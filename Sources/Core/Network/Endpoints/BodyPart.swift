//
//  BodyPart.swift
//  SnapsureSDK
//
//  Created by Dmitry Frishbuter on 24/11/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation

protocol BodyPart {
    
    var data: Data { get set }
    var name: String { get set }
    var fileName: String { get set }
    var mimeType: String { get set }
}

struct ImageBodyPart: BodyPart {
    
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
}
