//
//  TimerViewControllerTests.swift
//  UIKit-TimerTests
//
//  Created by Theo Vora on 3/7/23.
//

import XCTest
@testable import UIKit_Timer

final class TimerViewControllerTests: XCTestCase {
    
    func test_timerVC_acceptsMinutesParameter() {
        let minutes: UInt = 7
        let sut = TimerViewController(minutes: minutes)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.timeRemaining, minutes.seconds)
    }
    
    func test_timerVC_containsOneButton() {
        let sut = makeSUT()
        
        var buttons = [PlayPauseButton]()
        
        sut.view.subviews.forEach { subview in
            if let button = subview as? PlayPauseButton {
                buttons.append(button)
            }
        }
        
        XCTAssertEqual(buttons.count, 1)
    }
    
    func test_timerVC_tapPlayPauseButtonOnceWillToggleFromPlayToPause() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.playPauseButton.image, playImage)
        
        sut.playPauseButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(sut.playPauseButton.image, pauseImage)
    }
    
    func test_timerVC_pauseAfterStartingStopsTheCountdownTimer() {
        let sut = makeSUT()
        
        sut.playPauseButton.sendActions(for: .touchUpInside)
        
        expectAfter(seconds: TimerViewControllerTests.about1Second) {
            XCTAssertEqual(sut.countdownTimerLabel.text, "24:59")
            sut.playPauseButton.sendActions(for: .touchUpInside)
            XCTAssertEqual(sut.playPauseButton.icon, .Play)
        }
        
        expectAfter(seconds: TimerViewControllerTests.about1Second) {
            XCTAssertEqual(sut.countdownTimerLabel.text, "24:59")
        }
    }
    
    // MARK: - Helpers
    
    let playImage = UIImage(systemName: PlayPauseButton.Icon.Play.rawValue)
    let pauseImage = UIImage(systemName: PlayPauseButton.Icon.Pause.rawValue)
    
    static let about1Second: TimeInterval = 1.05
    
    private func makeSUT() -> TimerViewController {
        let sut = TimerViewController()
        sut.loadViewIfNeeded()
        return sut
    }
    
    private func expectAfter(
        seconds timeout: TimeInterval = about1Second,
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

private extension UInt {
    var seconds: UInt {
        self * 60
    }
}

private extension PlayPauseButton {
    var image: UIImage? {
        imageView?.image
    }
}
