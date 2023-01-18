//
//  TimerEngineNumber9Tests.swift
//  TimerEngineNumber9Tests
//
//  Created by Theo Vora on 1/13/23.
//

import XCTest
@testable import TimerEngineNumber9

final class TimerEngineNumber9Tests: XCTestCase {

    func test_canSet3SecondTimer() throws {
        let timer = TENTimer(3)
        
        let duration = timer.duration
        
        XCTAssertEqual(duration, 3)
    }
    
    func test_start1SecondTimer_entersStartedState() {
        let timer = startTimer()
        XCTAssertEqual(timer.state, .started)
    }
    
    func test_start1SecondTimer_completesCountdownFrom1Second() {
        let timer = startTimer()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(timer.state, .finished)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_start2SecondTimer_canPauseAfter1Second() {
        let timer = TENTimer(2)
        timer.start()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_start1SecondTimer_cannotPauseIfNotStarted() {
        let timer = TENTimer(1)
        timer.pause()
        XCTAssertNotEqual(timer.state, .paused, "Timer has not started. It should not be able to enter a paused state.")
    }
    
    func test_start1SecondTimer_cannotPauseIfFinished() {
        let timer = startTimer(1)
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertNotEqual(timer.state, .paused)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_start2SecondTimer_pausingAfter1SecondShouldShow1SecondRemains() {
        let timer = startTimer(2)
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 1)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_start3SecondTimer_pausingAfter1SecondShouldShow2SecondsRemains() {
        let timer = startTimer(3)
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 2)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    // MARK: - Helpers
    
    func startTimer(_ seconds: UInt = 1) -> TENTimer {
        let timer = TENTimer(seconds)
        timer.start()
        return timer
    }
}

class TENTimer {
    
    // MARK: - Public Properties
    
    /// duration in seconds
    public let duration: UInt
    public var state: State = .notStarted
    public var timeRemaining: UInt
    
    
    // MARK: - Private Properties
    
    private let oneSecond: Double = 1.0
    private var ticker: Timer?
    
    
    // MARK: - Public Methods
    
    public init(_ duration: UInt) {
        self.duration = duration
        self.timeRemaining = duration
    }
    
    public func start() {
        state = .started
        tick()
    }
    
    public func pause() {
        guard state == .started else { return }
        
        ticker?.invalidate()
        
        state = .paused
    }
    
    
    // MARK: - Private Methods
    
    private func tick() {
        ticker = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(tock), userInfo: nil, repeats: false)
    }
    
    @objc private func tock() {
        timeRemaining -= 1
        ticker?.invalidate()
        
        if timeRemaining == 0 {
            state = .finished
        } else {
            tick()
        }
    }
}

extension TENTimer {
    enum State {
        case notStarted
        case started
        case finished
        case paused
    }
}
