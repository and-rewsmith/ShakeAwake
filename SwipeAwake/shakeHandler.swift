//
//  shakeHandler.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/16/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation

import UIKit
import CoreMotion
import AVFoundation

class ShakeViewController: UIViewController {
    
    lazy var motionManager = CMMotionManager()
    var player: AVAudioPlayer?
    
    @IBOutlet weak var shakeLabel: UILabel!
    var shakeCount : Int = 0
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            player?.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
