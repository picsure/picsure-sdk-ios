//
//  LookupTask.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 16/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class LookupTask {
    
    private let id: Int
    private let timer: RequestTimer
    
    private var completion: Completion
    private weak var task: URLSessionDataTask?
    
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
        
        timer.timeIsOverHandler = { [unowned self] in
            self.task?.cancel()
            self.completion(.failure(SnapsureErrors.LookupErrors.timeout))
        }
    }
}
