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
    
    @IBOutlet weak var time: UILabel!
    
    func setFields(alarm: Alarm) {
        time.text = alarm.time
    }
}
