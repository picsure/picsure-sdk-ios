//
//  BodyPart.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

struct BodyPart {
    
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
    
    init(data: Data,
         name: String = "upload",
         fileName: String = "upload.jpg",
         mimeType: String = "image/jpeg") {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
