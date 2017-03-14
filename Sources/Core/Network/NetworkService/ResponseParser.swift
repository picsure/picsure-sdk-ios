//
//  ResponseParser.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 12/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class ResponseParser {
    
    /// Parses JSON with standart JSONSerialization object.
    ///
    /// - Parameter data: The data for parsing
    /// - Returns: Optional dictionary from parsed JSON.
    static func parseJSON(from data: Data) -> JSON? {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON {
            return json
        }
        return nil
    }
}
