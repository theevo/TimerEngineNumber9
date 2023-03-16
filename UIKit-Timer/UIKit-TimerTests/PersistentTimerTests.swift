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
}
