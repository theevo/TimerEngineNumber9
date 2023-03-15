//
//  TENTimer.swift
//  TENTimer
//
//  Created by Theo Vora on 3/7/23.
//

import Foundation

public protocol TENTimerDelegate {
    var secondsRemaining: UInt { get set }
    func didComplete()
}

public class TENTimer {
    
    // MARK: - Public Properties
    
    /// number of seconds set on this timer. remains constant even after timer has started.
    public let seconds: UInt
    public var state: State = .notStarted
    /// time remaining in *tenths* of a second. this value will update while the timer is counting down. Ex: value of 60 = 6 seconds
    public var decisecondsRemaining: UInt
    
    /// **warning**: this is not precise and will round to the nearest second
    public var secondsRemaining: UInt {
        decisecondsRemaining / 10
    }
    
    public var timeRemainingString: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        let leadingZero = seconds < 10 ? "0" : ""
        return "\(minutes):\(leadingZero)\(seconds).0"
    }
    
    // MARK: - Private Properties
    
    private static let secondsIn1Minute: UInt = 60
    
    private var delegate: TENTimerDelegate?
    private let oneSecond: Double = 1.0
    private let tenthOf1Second: Double = 0.1
    private var ticker: Timer?
    
    
    // MARK: - Public Methods
    
    public init(_ seconds: UInt) {
        self.seconds = seconds
        self.decisecondsRemaining = seconds * 10
    }
    
    public convenience init(minutes: UInt) {
        let seconds = minutes * TENTimer.secondsIn1Minute
        self.init(seconds)
    }
    
    public enum TimerError: Error {
        case cannotStartOnZero
    }
    
    public func start() throws {
        guard decisecondsRemaining > 0 else { throw TimerError.cannotStartOnZero }
        
        state = .started
        tick()
        print("Starting \(ObjectIdentifier(self)) of \(seconds) seconds")
    }
    
    public func subscribe(delegate: TENTimerDelegate) {
        self.delegate = delegate
    }
    
    public func pause() {
        guard state == .started else { return }
        
        ticker?.invalidate()
        
        state = .paused
    }
    
    
    // MARK: - Private Methods
    
    private func tick() {
        ticker = Timer.scheduledTimer(timeInterval: tenthOf1Second, target: self, selector: #selector(tock), userInfo: nil, repeats: true)
    }
    
    @objc private func tock() {
        decisecondsRemaining -= 1
        delegate?.secondsRemaining = secondsRemaining
        
        if decisecondsRemaining == 0 {
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
