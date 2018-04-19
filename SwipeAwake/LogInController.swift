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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navVC = segue.destination as! UINavigationController
        let destinationVC = navVC.topViewController as! AlarmSelectionController
        
        destinationVC.alarmsHandler = AlarmsHandler(user: "test", interval: 5)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColorFromHex(rgbValue:0x795791, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        //TESTING BELOW - COMMENT OUT WHEN YOU WANT
//        let alarmsHandler = AlarmsHandler(user: "TestUser", interval: 15)
//        let alarm1 = Alarm(time: "02:30", isSet: true)
//        alarmsHandler.turnOnAlarm(alarm: alarm1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

