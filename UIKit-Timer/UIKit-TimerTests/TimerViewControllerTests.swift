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
        XCTAssertEqual(sut.timer.timeRemaining.minutes, 7)
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
        let playImage = UIImage(systemName: PlayPauseButton.Icon.Play.rawValue)
        let pauseImage = UIImage(systemName: PlayPauseButton.Icon.Pause.rawValue)
        
        XCTAssertEqual(sut.playPauseButton.image, playImage)
        
        sut.playPauseButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(sut.playPauseButton.image, pauseImage)
    }
    
    func test_timerVC_startAdvancesCountdownTimerThenPauseStopsCountdownTimer() {
        let sut = makeSUT()
        
        sut.playPauseButton.sendActions(for: .touchUpInside) // play
        
        expectAfter(seconds: about1Second) {
            XCTAssertEqual(sut.countdownTimerLabel.text, "24:59")
            sut.playPauseButton.sendActions(for: .touchUpInside) // pause
        }
        
        expectAfter(seconds: about1Second) {
            XCTAssertEqual(sut.countdownTimerLabel.text, "24:59")
        }
    }
    
    // MARK: - Helpers
    
    let about1Second: TimeInterval = 1.05
    
    private func makeSUT() -> TimerViewController {
        let sut = TimerViewController()
        sut.loadViewIfNeeded()
        return sut
    }
}

private extension PlayPauseButton {
    var image: UIImage? {
        imageView?.image
    }
}
