//
//  SnapsureErrors.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

enum SnapsureErrors: Error {
    
    enum TokenErrors: Error {
        case missingToken
    }
    
    enum NetworkErrors: Error {
        case emptyServerData
        case cannotParseResponse
    }
    
    enum ImageErrors: Error {
        case unsupportedBitmapFormat
        case bigSize
    }
}

extension SnapsureErrors.TokenErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .missingToken: return "Missing token. Please call `SnapsureSDK.configure(withApiKey:)` function with your API key."
        }
    }
}

extension SnapsureErrors.NetworkErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyServerData: return "Server have sended empty data for request."
        case .cannotParseResponse: return "Server have sended incorrect response."
        }
    }
}

extension SnapsureErrors.ImageErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unsupportedBitmapFormat: return "Selected image has unsupported bitmap format."
        case .bigSize: return "Selected image has big size."
        }
    }
}
