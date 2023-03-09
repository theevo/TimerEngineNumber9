//
//  TimerViewController.swift
//  UIKit-Timer
//
//  Created by Theo Vora on 3/7/23.
//

import UIKit
import TENTimer

class PlayPauseButton: UIButton {
    enum Icon: String {
        case Play = "play.circle.fill"
        case Pause = "pause.circle.fill"
    }
    
    var icon: Icon = .Play
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        icon = icon == .Play ? .Pause : .Play
        updateView()
    }
    
    func updateView() {
        configuration = setConfiguration()
    }
    
    private func setConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon.rawValue)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 80)
        return config
    }
}

class TimerViewController: UIViewController {
    
    var timer = TENTimer(minutes: 25)
    
    var timeRemaining: UInt {
        timer.timeRemaining
    }
    
    var playPauseButton = PlayPauseButton()
    
    
    convenience init(minutes: UInt) {
        self.init()
        timer = TENTimer(minutes: minutes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addSubviews()
    }
    
    func addSubviews() {
        playPauseButton.addTarget(self, action: #selector(tapPlayPauseButton), for: .touchUpInside)
        
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func tapPlayPauseButton() {
        playPauseButton.toggle()
    }
}
