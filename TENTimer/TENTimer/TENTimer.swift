//
//  TENTimer.swift
//  TENTimer
//
//  Created by Theo Vora on 3/7/23.
//

import Foundation

public protocol TENTimerDelegate {
    var timeRemaining: UInt { get set }
    func didComplete()
}

public class TENTimer {
    
    // MARK: - Public Properties
    
    /// duration in seconds
    public let duration: UInt
    public var state: State = .notStarted
    public var timeRemaining: UInt
    
    public var timeRemainingString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return "\(minutes):\(seconds)"
    }
    
    // MARK: - Private Properties
    
    private static let secondsIn1Minute: UInt = 60
    
    private var delegate: TENTimerDelegate?
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
        ticker = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(tock), userInfo: nil, repeats: true)
    }
    
    @objc private func tock() {
        print(" Timer \(ObjectIdentifier(self)) of \(duration) seconds has **\(timeRemaining)** sec remaining")
        timeRemaining -= 1
        delegate?.timeRemaining = timeRemaining
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
