//
//  ViewController.swift
//  UIKit-Timer
//
//  Created by Theo Vora on 3/7/23.
//

import UIKit
import TENTimer

class ViewController: UIViewController {
    
    let timer = TENTimer(minutes: 1)
    
    var secondsRemaining: UInt {
        timer.timeRemaining
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Time remaining: \(secondsRemaining)")
    }


}

