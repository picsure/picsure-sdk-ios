//
//  RequestTimer.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

typealias TimeHandler = () -> Void

// TODO: Remove public later

public final class RequestTimer {
    
    private var intervalsTimer: Timer?
    private var isOverTimer: Timer?
    
    private let maxTime: TimeInterval
    private let intervals: [TimeInterval]
    private var currentIndexInterval = 0
    
    var timeIsOverHandler: TimeHandler?
    var nextIntervalHandler: TimeHandler?
    
    init(maxTime: TimeInterval, intervals: [TimeInterval]) {
        self.maxTime = maxTime
        self.intervals = intervals
    }
    
    // MARK: Timer actions
    
    func start() {
        intervalsTimer = Timer(timeInterval: intervals[currentIndexInterval],
                               target: self,
                               selector: #selector(intervalTimerTriggered),
                               userInfo: nil,
                               repeats: false)
        
        isOverTimer = Timer(timeInterval: maxTime,
                            target: self,
                            selector: #selector(overTimerTriggered),
                            userInfo: nil,
                            repeats: false)

        RunLoop.current.add(intervalsTimer!, forMode: .defaultRunLoopMode)
        RunLoop.current.add(isOverTimer!, forMode: .defaultRunLoopMode)
    }
    
    func `continue`() {
        currentIndexInterval += 1
        intervalsTimer = Timer(timeInterval: intervals[currentIndexInterval],
                               target: self,
                               selector: #selector(intervalTimerTriggered),
                               userInfo: nil,
                               repeats: false)
    }

    func stop() {
        intervalsTimer?.invalidate()
        isOverTimer?.invalidate()
        
        intervalsTimer = nil
        isOverTimer = nil
    }
    
    // MARK: Selector actions
    
    @objc private func intervalTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        nextIntervalHandler?()
    }
    
    @objc private func overTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        timeIsOverHandler?()
    }
}

public extension RequestTimer {
    
    static var `default` = RequestTimer(maxTime: 60, intervals: [10, 6, 6, 6, 6, 6, 6, 6, 6, 6])
}
