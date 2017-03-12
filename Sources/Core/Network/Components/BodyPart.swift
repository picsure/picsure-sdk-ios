//
//  BodyPart.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
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
