//
//  TimerEngine.swift
//  TimerEngineNumber9
//
//  Created by Theo Vora on 3/5/23.
//

import Foundation

public protocol TENTimerDelegate {
    func didComplete()
}

public class TENTimer {
    
    // MARK: - Public Properties
    
    public var delegate: TENTimerDelegate?
    /// duration in seconds
    public let duration: UInt
    public var state: State = .notStarted
    public var timeRemaining: UInt
    
    
    // MARK: - Private Properties
    
    private static let secondsIn1Minute: UInt = 60
    
    private let oneSecond: Double = 1.0
    private var ticker: Timer?
    
    
    // MARK: - Public Methods
    
    public init(_ duration: UInt) {
        self.duration = duration
        self.timeRemaining = duration
    }
    
    public convenience init(minutes: UInt) {
        let seconds = minutes * TENTimer.secondsIn1Minute
        self.init(seconds)
    }
    
    public func start() {
        state = .started
        tick()
        print("Starting \(ObjectIdentifier(self)) of \(duration) seconds")
    }
    
    public func pause() {
        guard state == .started else { return }
        
        ticker?.invalidate()
        
        state = .paused
    }
    
    
    // MARK: - Private Methods
    
    private func tick() {
        ticker = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(tock), userInfo: nil, repeats: true)
    }
    
    @objc private func tock() {
        print(" Timer \(ObjectIdentifier(self)) of \(duration) seconds has **\(timeRemaining)** sec remaining")
        timeRemaining -= 1
        print("  Timer \(ObjectIdentifier(self)) of \(duration) seconds has **\(timeRemaining)** sec remaining")
        
        if timeRemaining == 0 {
            state = .finished
            delegate?.didComplete()
            ticker?.invalidate()
        }
    }
}

extension TENTimer {
    public enum State {
        case notStarted
        case started
        case finished
        case paused
    }
}
