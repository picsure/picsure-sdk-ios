//
//  RequestTimer.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

final class RequestTimer {
    
    /// THe timer for interval handlers.
    private var intervalsTimer: Timer?
    /// The timer that triggers when timeout is over.
    private var isOverTimer: Timer?
    
    /// The timeout for interval handlers.
    private let timeout: TimeInterval
    /// The array for intervals.
    private let intervals: [TimeInterval]
    /// The index of current interval
    private var currentIndexInterval = 0
    
    /// Handles timeout event
    var timeoutHandler: (() -> Void)?
    /// Handles interval event.
    var nextIntervalHandler: ((RequestTimer) -> Void)?
    
    /// Initializes the timer with timeout and intervals.
    ///
    /// - Parameters:
    ///   - timeout: The time interval for stopping of interval timers.
    ///   - intervals: The intervals for interval handlers.
    init(timeout: TimeInterval, intervals: [TimeInterval]) {
        self.timeout = timeout
        self.intervals = intervals
    }
    
    // MARK: Timer actions
    
    /// Starts timer for current interval
    func start() {
        startIntervalsTimer()
        startTimeoutTimer()
    }
    
    /// Increments current interval index and starts the timer.
    func `continue`() {
        currentIndexInterval += 1
        startIntervalsTimer()
    }
    
    /// Stops current interval and timeout timers.
    func stop() {
        intervalsTimer?.invalidate()
        isOverTimer?.invalidate()
        
        intervalsTimer = nil
        isOverTimer = nil
    }
    
    // MARK: Helpers
    
    /// Creates the interval timer and add it to main runloop.
    private func startIntervalsTimer() {
        intervalsTimer = Timer(timeInterval: intervals[currentIndexInterval],
                               target: self,
                               selector: #selector(intervalTimerTriggered),
                               userInfo: nil,
                               repeats: false)
        RunLoop.main.add(intervalsTimer!, forMode: .defaultRunLoopMode)
    }
    
    /// Creates the timeout timer and add it to main runloop.
    private func startTimeoutTimer() {
        isOverTimer = Timer(timeInterval: timeout,
                            target: self,
                            selector: #selector(timeoutTimerTriggered),
                            userInfo: nil,
                            repeats: false)
        RunLoop.main.add(isOverTimer!, forMode: .defaultRunLoopMode)
    }
    
    // MARK: Selector actions
    
    /// Invalidates the interval timer and trigger next interval handler.
    @objc private func intervalTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        nextIntervalHandler?(self)
    }
    
    /// Invalidates the timeout timer and trigger timeout handler.
    @objc private func timeoutTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        timeoutHandler?()
    }
}

extension RequestTimer {
    
    /// The time with default intervals - 10 seconds delay, 6 seconds intervals and 60 seconds timeout.
    static var `default`: RequestTimer {
        return RequestTimer(timeout: 60, intervals: [10, 6, 6, 6, 6, 6, 6, 6, 6, 6])
    }
}
