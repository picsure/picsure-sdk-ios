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
    case invalidHost
    
    public enum TokenErrors: Error {
        case missingToken
        case invalidToken
    }
    
    public enum NetworkErrors: Error {
        case emptyServerData
        case cannotParseResponse
    }
    
    public enum ImageErrors: Error {
        case unsupportedBitmapFormat
        case bigSize
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
        case .invalidHost: return "The hostname is invalid."
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
        }
    }
}

extension PicsureErrors.ImageErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedBitmapFormat: return "Selected image has unsupported bitmap format."
        case .bigSize: return "Selected image has big size."
        }
    }
}
