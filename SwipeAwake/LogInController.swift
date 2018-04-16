//
//  LogInController.swift
//  SwipeAwake
//
//  Created by Rossi McCall on 4/15/18.
//  Copyright © 2018 Rossi McCall and Andrew Smith. All rights reserved.
//

import Foundation
import UIKit

class LogInController: UIViewController {
    
    // source: https://stackoverflow.com/questions/24112272/uiview-background-color-in-swift
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorFromHex(rgbValue:0x795791, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //TESTING BELOW - COMMENT OUT WHEN YOU WANT
        let alarmsHandler = AlarmsHandler(user: "TestUser", interval: 15)
        let alarm1 = Alarm(time: "02:30", isSet: true)
        alarmsHandler.turnOnAlarm(alarm: alarm1)
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

