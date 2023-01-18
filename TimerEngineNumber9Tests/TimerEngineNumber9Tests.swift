//
//  TimerEngineNumber9Tests.swift
//  TimerEngineNumber9Tests
//
//  Created by Theo Vora on 1/13/23.
//

import XCTest
@testable import TimerEngineNumber9

final class TimerEngineNumber9Tests: XCTestCase {

    func test_Timer_canSet3SecondDuration() throws {
        let timer = TENTimer(3)
        
        let duration = timer.duration
        
        XCTAssertEqual(duration, 3)
    }
    
    func test_Timer_entersStartedStateWhenTimerStarted() {
        let timer = build1SecondTimerAndStartIt()
        XCTAssertEqual(timer.state, .started)
    }
    
    func test_Timer_completesCountdownFrom1Second() {
        let timer = build1SecondTimerAndStartIt()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(timer.state, .finished)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_Timer_canPauseAfter1SecondAfterValidStart() {
        let timer = TENTimer(2)
        timer.start()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_Timer_cannotPauseIfNotStarted() {
        let timer = TENTimer(1)
        timer.pause()
        XCTAssertNotEqual(timer.state, .paused, "Timer has not started. It should not be able to enter a paused state.")
    }
    
    func test_Timer_cannotPauseIfFinished() {
        let timer = TENTimer(1)
        timer.start()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertNotEqual(timer.state, .paused)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    // MARK: - Helpers
    
    func build1SecondTimerAndStartIt() -> TENTimer {
        let timer = TENTimer(1)
        timer.start()
        return timer
    }
}

class TENTimer {
    /// duration in seconds
    public var duration: UInt
    public var state: State = .notStarted
    
    var doubleDuration: Double {
        Double(duration)
    }
    
    var timer: Timer?
    
    public init(_ duration: UInt) {
        self.duration = duration
    }
    
    public func start() {
        state = .started
        timer = Timer.scheduledTimer(timeInterval: doubleDuration, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
    }
    
    public func pause() {
        guard state == .started else { return }
        
        timer?.invalidate()
        
        state = .paused
    }
    
    @objc func timerFinished() {
        state = .finished
        timer?.invalidate()
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
