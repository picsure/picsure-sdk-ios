//
//  LookupService.swift
//  SnapsureSDK
//
//  Created by Artem Novichkov on 16/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class LookupService {
    
    private let id: Int
    private let timer: RequestTimer
    
    var completion: Completion?
    private var task: URLSessionDataTask?
    
    init(id: Int) {
        self.id = id
        timer = .default
        configureTimer()
    }
    
    func start() {
        timer.start()
    }
    
    private func configureTimer() {
        let imageID = id
        timer.nextIntervalHandler = { [unowned self] timer in
            self.task = NetworkService.shared.checkImageTask(for: LookupEndpoint.lookup(imageID), completion: { result in
                switch result {
                case .failure:
                    timer.continue()
                case .success(let json):
                    self.completion?(.success(json))
                }
            })
        }
        
        timer.timeIsOverHandler = { [unowned self] in
            self.task?.cancel()
            self.completion?(.failure(SnapsureErrors.LookupErrors.timeout))
        }
    }
}
