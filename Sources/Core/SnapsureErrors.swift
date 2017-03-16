//
//  SnapsureErrors.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

public enum SnapsureErrors: Error {
    
    public enum TokenErrors: Error {
        case missingToken
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

extension SnapsureErrors.TokenErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .missingToken: return "Missing token. Please call `SnapsureSDK.configure(withApiKey:)` function with your API key."
        }
    }
}

extension SnapsureErrors.NetworkErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .emptyServerData: return "Server has sended empty data for request."
        case .cannotParseResponse: return "Server has sended incorrect response."
        }
    }
}

extension SnapsureErrors.ImageErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedBitmapFormat: return "Selected image has unsupported bitmap format."
        case .bigSize: return "Selected image has big size."
        }
    }
}
