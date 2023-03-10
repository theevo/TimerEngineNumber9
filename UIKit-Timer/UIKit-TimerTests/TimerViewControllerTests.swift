//
//  TimerViewControllerTests.swift
//  UIKit-TimerTests
//
//  Created by Theo Vora on 3/7/23.
//

import XCTest
@testable import UIKit_Timer

final class TimerViewControllerTests: XCTestCase {

    func test_timeRemaining_hasIntegerValue() {
        let sut = makeSUT()
        XCTAssertGreaterThanOrEqual(sut.timeRemaining, 0)
    }
    
    func test_timerVC_acceptsMinutesParameter() {
        let minutes: UInt = 7
        let sut = TimerViewController(minutes: minutes)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.timeRemaining, minutes.seconds)
    }
    
    func test_button_showsPlayWhenLoaded() {
        let sut = PlayPauseButton()
        XCTAssertEqual(sut.icon, .Play)
        XCTAssertEqual(sut.imageView?.image, UIImage(systemName: "play.circle.fill"))
    }
    
    func test_button_togglesFromPlayToPause() {
        let sut = PlayPauseButton()
        sut.toggle()
        XCTAssertEqual(sut.icon, .Pause)
        XCTAssertEqual(sut.image, UIImage(systemName: "pause.circle.fill"))
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
        
        XCTAssertEqual(sut.playPauseButton.icon, .Play)
        
        sut.playPauseButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(sut.playPauseButton.icon, .Pause)
    }
    
    func test_timerVC_displaysCountdownTimer() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.countdownTimerLabel.text, "countdownTimerLabel.text should not be nil")
        XCTAssertFalse(sut.countdownTimerLabel.text?.isEmpty ?? true, "countdownTimerLabel.text should not be empty")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> TimerViewController {
        let sut = TimerViewController()
        sut.loadViewIfNeeded()
        return sut
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
