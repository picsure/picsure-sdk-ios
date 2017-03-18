//
//  LookupService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 18/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

final class LookupService {
    
    private var lookupTasks = [Int: LookupTask]()
    
    static var shared = LookupService()
    
    private init() {}
    
    func addLookupTask(for id: Int, completion: @escaping Completion) {
        let service = LookupTask(id: id) { [weak self] result in
            self?.lookupTasks[id] = nil
            completion(result)
        }
        service.start()
        lookupTasks[id] = service
    }
}
