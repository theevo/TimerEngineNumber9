//
//  TimerViewController.swift
//  UIKit-Timer
//
//  Created by Theo Vora on 3/7/23.
//

import UIKit
import TENTimer

class PlayPauseButton: UIButton {
    enum Icon {
        case Play
        case Pause
    }
    
    var icon: Icon = .Play
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        icon = icon == .Play ? .Pause : .Play
    }
}

class TimerViewController: UIViewController {
    
    var timer = TENTimer(minutes: 25)
    
    var timeRemaining: UInt {
        timer.timeRemaining
    }
    
    convenience init(minutes: UInt) {
        self.init()
        timer = TENTimer(minutes: minutes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Time remaining: \(timeRemaining)")
    }


}
