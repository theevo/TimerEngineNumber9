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
        let timer = makeTimer(seconds: 3)
        
        XCTAssertEqual(timer.duration, 3)
    }
    
    func test_start1SecondTimer_entersStartedState() {
        let timer = startTimer()
        XCTAssertEqual(timer.state, .started)
        timer.pause() // deallocate timer
    }
    
    func test_start1SecondTimer_finishesAfter1Second() {
        let timer = startTimer()
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            XCTAssertEqual(timer.state, .finished)
        }
    }
    
    func test_start2SecondTimer_pauseAfter1SecondEntersPauseState() {
        let timer = startTimer(seconds: 2)
        
        expectAfter(
            seconds: TimeInterval.about1Second,
            timer: timer) {
                timer.pause()
                XCTAssertEqual(timer.state, .paused)
            }
    }
    
    func test_create1SecondTimer_cannotPauseIfNotStarted() {
        let timer = makeTimer()
        timer.pause()
        XCTAssertNotEqual(timer.state, .paused, "Timer has not started. It should not be able to enter a paused state.")
    }
    
    func test_start1SecondTimer_cannotPauseIfFinished() {
        let timer = startTimer()
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            timer.pause()
            XCTAssertNotEqual(timer.state, .paused)
        }
}
    
    func test_start2SecondTimer_pausingAfter1SecondShouldShow1SecondRemains() {
        let timer = startTimer(seconds: 2)
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 1)
        }
    }
    
    func test_start3SecondTimer_pausingAfter1SecondShouldShow2SecondsRemains() {
        let timer = startTimer(seconds: 3)
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 2)
        }
    }
    
    func test_start1MinuteTimer_pausingAfter1SecondShouldShow59SecondsRemaining() {
        let timer = TENTimer(minutes: 1)
        timer.start()
        trackForMemoryLeaks(timer)
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            timer.pause()
            XCTAssertEqual(timer.state, .paused)
            XCTAssertEqual(timer.timeRemaining, 59)
        }
    }
    
    func test_subscribe_1secondTimerShouldCallbackWhenFinished() {
        let timer = makeTimer()
        let spy = makeSpy()
        
        timer.subscribe(delegate: spy)
        timer.start()
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            XCTAssertTrue(spy.didFinish)
        }
    }
    
    func test_subscribe_2secondTimerShouldCallbackEachSecond() {
        let timer = makeTimer(seconds: 2)
        let spy = makeSpy()
        
        trackForMemoryLeaks(spy)
        
        timer.subscribe(delegate: spy)
        timer.start()
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            XCTAssertEqual(spy.timeRemaining, 1)
        }
        
        expectAfter(seconds: TimeInterval.about1Second, timer: timer) {
            XCTAssertEqual(spy.timeRemaining, 0)
        }
    }
    
    // MARK: - Helpers
    
    private func expectAfter(
        seconds: TimeInterval,
        timer: TENTimer,
        assertion: () -> Void
    ) {
        let exp = expectation(description: "Test after \(seconds) second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.05)
        if result == XCTWaiter.Result.timedOut {
            assertion()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    private func makeTimer(seconds: UInt = 1, file: StaticString = #filePath, line: UInt = #line) -> TENTimer {
        let timer = TENTimer(seconds)
        trackForMemoryLeaks(timer, file: file, line: line)
        return timer
    }
    
    private func startTimer(seconds: UInt = 1, file: StaticString = #filePath, line: UInt = #line) -> TENTimer {
        let timer = makeTimer(seconds: seconds, file: file, line: line)
        timer.start()
        return timer
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
    var timeRemaining: UInt = 2
    
    func didComplete() {
        didFinish = true
        print("**** this timer finished! ****")
    }
}

extension TimeInterval {
    fileprivate static let about1Second: TimeInterval = 1.05
}
