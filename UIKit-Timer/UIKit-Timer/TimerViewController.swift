//
//  TimerViewController.swift
//  UIKit-Timer
//
//  Created by Theo Vora on 3/7/23.
//

import UIKit
import TENTimer

class TimerViewController: UIViewController {
    
    var timer = TENTimer(minutes: 25)
    
    var playPauseButton = PlayPauseButton()
    
    var countdownTimerLabel = UILabel()
    
    
    convenience init(minutes: UInt) {
        self.init()
        timer = TENTimer(minutes: minutes)
    }
    
    convenience init(seconds: UInt) {
        self.init()
        timer = TENTimer(seconds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        layoutSubviews()
    }
    
    func configureSubviews() {
        countdownTimerLabel.text = timer.timeRemainingString
        countdownTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownTimerLabel.font = UIFont.systemFont(ofSize: 75, weight: .regular)
        
        timer.subscribe(delegate: self)
        
        playPauseButton.addTarget(self, action: #selector(tapPlayPauseButton), for: .touchUpInside)
    }
    
    func layoutSubviews() {
        view.addSubview(countdownTimerLabel)
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            countdownTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NSLayoutConstraint(item: countdownTimerLabel, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 0.5, constant: 0),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func tapPlayPauseButton() {
        switch timer.state {
        case .notStarted, .paused:
            playPauseButton.toggle()
            try! timer.start()
        case .started:
            playPauseButton.toggle()
            timer.pause()
        case .finished:
            // do nothing
            return
        }
    }
}

extension TimerViewController: TENTimerDelegate {
    func timerTicked(timeLeft: (minutes: UInt, seconds: UInt, deciseconds: UInt)) {
        countdownTimerLabel.text = timer.timeRemainingString
    }
    
    func didComplete() {
        print("timer finished")
    }
}


