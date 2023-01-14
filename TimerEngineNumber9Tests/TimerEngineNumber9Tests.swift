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
    
    func test_Timer_canStart() async {
        var timer = TENTimer(1)
        await timer.start()
        
        let didStart = timer.didStart
        
        XCTAssertEqual(didStart, true)
    }
    
    func test_Timer_canCountdownFrom1Second() async {
        var timer = TENTimer(1)

        await timer.start()

        XCTAssertEqual(timer.didFinish, true)
    }

}

struct TENTimer {
    /// duration in seconds
    public var duration: UInt
    public var didStart: Bool = false
    public var didFinish: Bool = false
    
    var nanosDuration: UInt64 {
        UInt64(duration * 1_000_000_000)
    }
    
    public init(_ duration: UInt) {
        self.duration = duration
    }
    
    public mutating func start() async {
        do {
            try await Task.sleep(nanoseconds: nanosDuration)
            didStart = true
            didFinish = true
        } catch {
            print(error)
        }
    }
}
