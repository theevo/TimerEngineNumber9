//
//  TimerEngineNumber9Tests.swift
//  TimerEngineNumber9Tests
//
//  Created by Theo Vora on 1/13/23.
//

import XCTest
import TimerEngineNumber9

final class TimerEngineNumber9Tests: XCTestCase {

    func test_create3SecondTimer_shouldShow3secondsRemaining() throws {
        let timer = TENTimer(3)
        
        XCTAssertEqual(timer.duration, 3)
    }
    
    func test_start1SecondTimer_entersStartedState() {
        let timer = makeTimer()
        XCTAssertEqual(timer.state, .started)
    }
    
    func test_start1SecondTimer_completesCountdownFrom1Second() {
        let timer = makeTimer()
        
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
        let timer = makeTimer(seconds: 1)
        
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
        let timer = makeTimer(seconds: 2)
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 1)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_start3SecondTimer_pausingAfter1SecondShouldShow2SecondsRemains() {
        let timer = makeTimer(seconds: 3)
        
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
    
    func makeTimer(seconds: UInt = 1) -> TENTimer {
        let timer = TENTimer(seconds)
        timer.start()
        return timer
    }
}
