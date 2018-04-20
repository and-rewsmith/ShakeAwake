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
    
    @IBOutlet weak var userEntry: UITextField!
    
    
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RegistrationController, let username = sourceViewController.username {
            
            userEntry.text = username
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Register" {
            
        }
        
        if segue.identifier == "AlarmSelection" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AlarmSelectionController
            
            destinationVC.alarmsHandler = AlarmsHandler(user: "test", interval: 5)
        }

        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColorFromHex(rgbValue:0x795791, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
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

