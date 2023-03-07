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
