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
        
        app.pressButton() // intent: start
        
        expectAfter(seconds: about1Second) {
            let str = app.staticTexts.element(matching: .any, identifier: "time remaining").label
            XCTAssertTrue(str.hasPrefix("24:59"), "Received \(str) instead")
            app.pressButton() // intent: pause
        }
    }
    
    // MARK: - Helpers
    
    let about1Second: TimeInterval = 0.85
}

fileprivate extension XCUIApplication {
    func pressButton() {
        self.buttons.element(matching: .button, identifier: "start pause button").tap()
    }
}
