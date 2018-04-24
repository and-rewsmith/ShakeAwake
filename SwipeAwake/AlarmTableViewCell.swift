//
//  AlarmTableViewCell.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/16/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    var onButtonTapped : (() -> Void)? = nil

    @IBOutlet weak var toggleButton: UIButton!
    
    @IBAction func toggleAlarm(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    @IBOutlet weak var time: UILabel!
    
    func setFields(alarm: Alarm) {
        time.text = alarm.time
        
        if alarm.isSet {
            toggleButton.backgroundColor = UIColor(red: 45/255, green: 252/255, blue: 173/255, alpha: 1)
        }
        else {
            toggleButton.backgroundColor = UIColor.gray
        }
        
        toggleButton.addTarget(self, action: #selector (toggleAlarm), for: UIControlEvents.touchDown)
    }
}
