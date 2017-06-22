//
//  RequestTimer.swift
//  Snapsure
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class RequestTimer {
    
    /// The timer for interval handlers.
    private var intervalsTimer: Timer?
    
    /// The timer that triggers when time is over.
    private var timeoutTimer: Timer?
    
    /// The timeout after which the `timeoutHandler` will be triggered.
    private let timeout: TimeInterval
    
    /// The intervals after each of which the `nextIntervalHandler` will be triggered.
    private let intervals: [TimeInterval]
    
    /// The object for observing of notifications. Default instance is `NotificationCenter.default`.
    private let notification: Notification
    
    /// The index of current interval.
    private var currentIntervalIndex = 0
    
    /// Handles timeout event.
    var timeoutHandler: (() -> Void)?
    
    /// Handles interval event.
    var nextIntervalHandler: ((RequestTimer) -> Void)?
    
    /// Initializes the timer with timeout and intervals.
    ///
    /// - Parameters:
    ///   - timeout: The timeout after which the `timeoutHandler` will be triggered.
    ///   - intervals: The intervals after each of which the `nextIntervalHandler` will be triggered.
    ///   - notification: The object for observing of notifications. Default instance is `NotificationCenter.default`.
    init(timeout: TimeInterval, intervals: [TimeInterval], notification: Notification = NotificationCenter.default) {
        self.timeout = timeout
        self.intervals = intervals
        self.notification = notification
        
        notification.addObserver(self,
                                 selector: #selector(appDidEnterBackground),
                                 name: NSNotification.Name.UIApplicationDidEnterBackground,
                                 object: nil)
        notification.addObserver(self,
                                 selector: #selector(appDidBecomeActive),
                                 name: NSNotification.Name.UIApplicationDidBecomeActive,
                                 object: nil)
    }
    
    deinit {
        intervalsTimer?.invalidate()
        timeoutTimer?.invalidate()
        
        notification.removeObserver(self)
    }
    
    // MARK: Timer actions
    
    /// Starts timer.
    func start() {
        startIntervalsTimer()
        startTimeoutTimer()
    }
    
    /// Continues timer with next interval.
    func `continue`() {
        currentIntervalIndex += 1
        startIntervalsTimer()
    }
    
    /// Stops timer.
    func stop() {
        intervalsTimer?.invalidate()
        timeoutTimer?.invalidate()
        
        intervalsTimer = nil
        timeoutTimer = nil
        
        currentIntervalIndex = 0
    }
    
    // MARK: Helpers
    
    private func startIntervalsTimer() {
        intervalsTimer = Timer(timeInterval: intervals[currentIntervalIndex],
                               target: self,
                               selector: #selector(intervalTimerTriggered),
                               userInfo: nil,
                               repeats: false)
        RunLoop.main.add(intervalsTimer!, forMode: .defaultRunLoopMode)
    }
    
    private func startTimeoutTimer() {
        timeoutTimer = Timer(timeInterval: timeout,
                             target: self,
                             selector: #selector(timeoutTimerTriggered),
                             userInfo: nil,
                             repeats: false)
        RunLoop.main.add(timeoutTimer!, forMode: .defaultRunLoopMode)
    }
    
    // MARK: Selector actions
    
    @objc private func intervalTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        nextIntervalHandler?(self)
    }
    
    @objc private func timeoutTimerTriggered() {
        intervalsTimer?.invalidate()
        intervalsTimer = nil
        timeoutHandler?()
    }
    
    // MARK: - Notifications
    
    @objc private func appDidEnterBackground() {
        stop()
    }
    
    @objc private func appDidBecomeActive() {
        start()
    }
}

extension RequestTimer {
    
    /// The time with default intervals - 10 seconds delay, 6 seconds intervals and 60 seconds timeout.
    static var `default`: RequestTimer {
        return RequestTimer(timeout: 60, intervals: [10, 6, 6, 6, 6, 6, 6, 6, 6, 6])
    }
}
