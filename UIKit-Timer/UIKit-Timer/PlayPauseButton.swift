//
//  PlayPauseButton.swift
//  UIKit-Timer
//
//  Created by Theo Vora on 3/14/23.
//

import UIKit

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
