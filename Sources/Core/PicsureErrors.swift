//
//  PicsureErrors.swift
//  Picsure
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import Foundation

public enum PicsureErrors: Error {
    
    case noResult
    case cannotRecognize
    
    public enum TokenErrors: Error {
        case missingToken
        case invalidToken
    }
    
    public enum NetworkErrors: Error {
        case emptyServerData
        case cannotParseResponse
        case server
    }
    
    public enum ImageErrors: Error {
        case unsupportedBitmapFormat
    }
    
    public enum LookupErrors: Error {
        case timeout
    }
}

extension PicsureErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noResult: return "No products for this image found."
        case .cannotRecognize: return "The image can not be recognized."
        }
    }
}

extension PicsureErrors.TokenErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .missingToken: return "Missing token. Please call `Picsure.configure(withApiKey:)` function with your API key."
        case .invalidToken: return "Unauthorized. Please check your API key."
        }
    }
}

extension PicsureErrors.NetworkErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .emptyServerData: return "Server has sent empty data for request."
        case .cannotParseResponse: return "Server has sent incorrect response."
        case .server: return "An Error occured - please check your API key or shout a message to support@picsure.ai"
        }
    }
}

extension PicsureErrors.ImageErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedBitmapFormat: return "Selected image has unsupported bitmap format."
        }
    }
}
