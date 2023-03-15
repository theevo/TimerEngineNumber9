//
//  TENTimerTests.swift
//  TENTimerTests
//
//  Created by Theo Vora on 3/7/23.
//

import XCTest
import TENTimer

final class TimerEngineNumber9Tests: XCTestCase {

    func test_create3SecondTimer_shouldShow3secondsRemaining() throws {
        let timer = makeTimer(seconds: 3)
        
        XCTAssertEqual(timer.seconds, 3)
    }
    
    func test_start1SecondTimer_entersStartedState() {
        let timer = startTimer()
        XCTAssertEqual(timer.state, .started)
        timer.pause() // deallocate timer
    }
    
    func test_start1SecondTimer_finishesAfter1Second() {
        let timer = startTimer()
        
        expectAfter(seconds: about1Second) {
            XCTAssertEqual(timer.state, .finished)
        }
    }
    
    func test_create1SecondTimer_cannotPauseIfNotStarted() {
        let timer = makeTimer(seconds: 1)
        timer.pause()
        XCTAssertNotEqual(timer.state, .paused, "Timer has not started. It should not be able to enter a paused state.")
    }
    
    func test_start1SecondTimer_cannotPauseIfFinished() {
        let timer = startTimer()
        
        expectAfter(seconds: about1Second) {
            timer.pause()
            XCTAssertNotEqual(timer.state, .paused)
        }
}
    
    func test_start2SecondTimer_pausingAfter1SecondShouldShow1SecondRemains() {
        let timer = startTimer(seconds: 2)
        
        expectAfter(seconds: about1Second) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.secondsRemaining, 1)
        }
    }
    
    func test_start3SecondTimer_pausingAfter2SecondsShouldShow1SecondsRemains() {
        let timer = startTimer(seconds: 3)
        
        expectAfter(seconds: 2.05) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.secondsRemaining, 1)
        }
    }
    
    func test_start1MinuteTimer_pausingAfter1SecondShouldShow59SecondsRemaining() {
        let timer = makeTimer(minutes: 1)
        start(timer)
//        trackForMemoryLeaks(timer)
        
        expectAfter(seconds: about1Second) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.secondsRemaining, 59)
        }
    }
    
    func test_subscribe_2secondTimerShouldCallbackEachSecond() {
        let timer = makeTimer(seconds: 2)
        let spy = makeSpy()
        
        timer.subscribe(delegate: spy)
        start(timer)
        
        expectAfter(seconds: about1Second) {
            XCTAssertEqual(spy.secondsRemaining, 1)
        }
        
        expectAfter(seconds: about1Second) {
            XCTAssertEqual(spy.secondsRemaining, 0)
        }
    }
    
    func test_timeRemainingString_secondsShouldHaveLeadingZero() {
        let timer = makeTimer(seconds: 69)

        XCTAssertEqual(timer.timeRemainingString, "1:09.0")
    }
    
    func test_timeRemainingString_minutesShouldShowZeroExplicitly() {
        let timer = makeTimer(seconds: 59)

        XCTAssertEqual(timer.timeRemainingString, "0:59.0")
    }
    
    func test_timeRemainingString_zeroSecondsShouldShow4Zeros() {
        let timer = makeTimer(seconds: 0)

        XCTAssertEqual(timer.timeRemainingString, "0:00.0")
    }
    
    func test_start5secondTimer_pauseAfterOneTenthOfSecondShouldYield4point9Remaining() {
        let timer = startTimer(seconds: 5)
        
        expectAfter(seconds: tenthOf1Second) {
            timer.pause()
            XCTAssertEqual(timer.decisecondsRemaining, 49)
            XCTAssertEqual(timer.timeRemainingString, "0:04.9")
        }
    }
    
    func test_start1secondTimer_pauseAfter9TenthsShouldYield0point1Remaining() {
        let timer = startTimer(seconds: 1)
        
        expectAfter(seconds: 0.9) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.decisecondsRemaining, 1)
            XCTAssertEqual(timer.timeRemainingString, "0:00.1")
        }
    }
    
    func test_start_throwsErrorIfTimerInitWithZeroSeconds() throws {
        let timer = makeTimer(seconds: 0)
        
        do {
            try timer.start()
            
            XCTFail("Expected error .cannotStartOnZero. No error was received.")
        } catch let error {
            XCTAssertEqual(error as! TENTimer.TimerError, TENTimer.TimerError.cannotStartOnZero)
            XCTAssertEqual(timer.state, .notStarted)
        }
    }
    
    // MARK: - Helpers
    
    let about1Second: TimeInterval = 1.05
    let tenthOf1Second: TimeInterval = 0.1
    
    private func expectAfter(
        seconds timeout: TimeInterval,
        assertion: () -> Void
    ) {
        let exp = expectation(description: "Test after \(timeout) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: timeout)
        if result == XCTWaiter.Result.timedOut {
            assertion()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    private func makeTimer(minutes: UInt = 0, seconds: UInt = 0, file: StaticString = #filePath, line: UInt = #line) -> TENTimer {
        
        let startSeconds = (minutes * 60) + seconds
        let timer = TENTimer(startSeconds)
        trackForMemoryLeaks(timer, file: file, line: line)
        return timer
    }
    
    private func startTimer(seconds: UInt = 1, file: StaticString = #filePath, line: UInt = #line) -> TENTimer {
        let timer = makeTimer(seconds: seconds, file: file, line: line)
        start(timer)
        return timer
    }
    
    private func start(_ timer: TENTimer, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try timer.start()
        } catch let error {
            XCTFail("Error when attempting to start timer: \(error)", file: file, line: line)
        }
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak. \(String(describing: instance?.description)) should have been deallocated.", file: file, line: line)
        }
    }
    
    private func makeSpy() -> TENTimerSpy {
        let spy = TENTimerSpy()
        trackForMemoryLeaks(spy)
        return spy
    }
}

private class TENTimerSpy: TENTimerDelegate {
    var didFinish = false
    var secondsRemaining: UInt = 2
    
    func didComplete() {
        didFinish = true
        print("**** this timer finished! ****")
    }
}
