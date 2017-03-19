//
//  LookupTask.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 16/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class LookupTask {
    
    /// The id of uploaded image.
    private let id: Int
    /// The timer for request repeating.
    private let timer: RequestTimer
    
    /// The completion for
    private var completion: Completion
    /// The data task
    private weak var task: URLSessionDataTask?
    
    /// Initializes the task with the id and the completion. The tasl uses
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
    
    func start() {
        timer.start()
    }
    
    private func configureTimer() {
        let imageID = id
        timer.nextIntervalHandler = { [unowned self] timer in
            
            self.task = NetworkService.shared.checkImageTask(for: LookupEndpoint.lookup(imageID)) { json, code, error in
                debugPrint(json ?? "no json")
                debugPrint(error)
                if let error = error {
                    if code == 404 {
                        timer.continue()
                    }
                    else {
                        //TODO: not found error
//                        self.completion(.failuer())
                    }
                }
                else if let json = json {
                    timer.stop()
                    self.completion(.success(json))
                }
            }
            self.task?.resume()
        }
        
        timer.timeoutHandler = { [unowned self] in
            self.task?.cancel()
            self.completion(.failure(SnapsureErrors.LookupErrors.timeout))
        }
    }
}
