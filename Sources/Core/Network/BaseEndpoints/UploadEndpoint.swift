//
//  UploadEndpoint.swift
//  Picsure
//
//  Created by Artem Novichkov on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

protocol UploadEndpoint: RequestEndpoint {
    
    var bodyPart: BodyPart { get }
}
