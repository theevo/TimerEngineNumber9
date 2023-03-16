//
//  PersistentTimerTests.swift
//  UIKit-TimerTests
//
//  Created by Theo Vora on 3/16/23.
//

import XCTest
import TENTimer

class PersistentTimer: TENTimer { }

final class PersistentTimerTests: XCTestCase {

    func test_set5minuteTimer_shouldHave5minutesRemaininig() {
        let timer = PersistentTimer(minutes: 5)
        
        XCTAssertEqual(timer.timeRemaining.minutes, 5)
    }
    
    func test_set5minuteTimer_timerRemembers5minutes() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons.element(matching: .button, identifier: "start pause button").tap()
        
        let exp = expectation(description: "Test after 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            let str = app.staticTexts.element(matching: .any, identifier: "time remaining").label
            XCTAssertTrue(str.hasPrefix("24:58"), "Received \(str) instead")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
