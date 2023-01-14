//
//  TimerEngineNumber9Tests.swift
//  TimerEngineNumber9Tests
//
//  Created by Theo Vora on 1/13/23.
//

import XCTest
@testable import TimerEngineNumber9

final class TimerEngineNumber9Tests: XCTestCase {

    func test_Timer_canReceive3SecondDuration() throws {
        let timer = TENTimer(3)
        
        let duration = timer.duration
        
        XCTAssertEqual(duration, 3)
    }
    
    func test_Timer_canStart() {
        var timer = TENTimer(3)
        timer.start()
        
        let didStart = timer.didStart
        
        XCTAssertEqual(didStart, true)
    }

}

struct TENTimer {
    public var duration: UInt
    public var didStart: Bool = false
    
    public init(_ duration: UInt) {
        self.duration = duration
    }
    
    public mutating func start() {
        didStart = true
    }
}
