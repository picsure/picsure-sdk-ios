//
//  LookupTask.swift
//  Snapsure
//
//  Created by Artem Novichkov on 16/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class LookupTask {
    
    /// The id of uploaded image.
    private let id: Int
    
    /// The timer for request repeating.
    private let timer: RequestTimer
    
    /// The completion for lookup request.
    private var completion: Completion
    
    /// The data task
    private weak var task: URLSessionDataTask?
    
    /// Initializes the task with the id and the completion.
    ///
    /// - Parameters:
    ///   - id: The id of uploaded image.
    ///   - completion: The completion for lookup request.
    init(id: Int, completion: @escaping Completion) {
        self.id = id
        self.completion = completion
        timer = .default
        configureTimer()
    }

    /// Starts request sending with default time intervals. 
    ///
    /// - see: `RequestTimer.default`.
    func start() {
        timer.start()
    }
    
    /// Configures handlers for request timer.
    private func configureTimer() {
        timer.nextIntervalHandler = { [unowned self] timer in
            
            self.task = NetworkService.shared.dataTask(for: LookupEndpoint.lookup(self.id)) { json, code, error in
                if let error = error {
                    if code == 404 {
                        timer.continue()
                    }
                    else {
                        timer.stop()
                        self.completion(.failure(error))
                    }
                }
                else if let json = json {
                    timer.stop()
                    if let _ = json["result"] as? NSNull {
                        self.completion(.failure(SnapsureErrors.noResult))
                    }
                    else {
                        self.completion(.success(json))
                    }
                }
            }
            self.task?.resume()
        }
        
        timer.timeoutHandler = { [unowned self] in
            self.task?.cancel()
            self.completion(.failure(SnapsureErrors.cannotRecognize))
        }
    }
}
