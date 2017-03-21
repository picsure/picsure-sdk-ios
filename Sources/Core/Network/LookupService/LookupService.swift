//
//  LookupService.swift
//  Snapsure
//
//  Created by Artem Novichkov on 18/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class LookupService {
    
    private var lookupTasks = [Int: LookupTask]()
    
    static var shared = LookupService()
    
    private init() {}
    
    /// Initializes a new `LookupTask` and contains it for concurrent execution.
    ///
    /// - Parameters:
    ///   - json: The json which contains the successful information about the uploaded image.
    ///   - completion: The completion which triggers after the execution of lookup task.
    func addLookupTask(for json: JSON, completion: @escaping Completion) {
        guard let id = json["id"] as? Int else {
            completion(.failure(SnapsureErrors.NetworkErrors.cannotParseResponse))
            return
        }
        let service = LookupTask(id: id) { [weak self] result in
            self?.lookupTasks[id] = nil
            completion(result)
        }
        service.start()
        lookupTasks[id] = service
    }
}
