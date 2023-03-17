//
//  XCTestCase+Extensions.swift
//  UIKit-TimerTests
//
//  Created by Theo Vora on 3/17/23.
//

import XCTest

public extension XCTestCase {
    
    func expectAfter(
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
}
