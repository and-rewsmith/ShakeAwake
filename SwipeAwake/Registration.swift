//
//  signupController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/19/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import UIKit

class RegistrationController: UIViewController {
    
    @IBOutlet weak var userEntry: UITextField!
    @IBOutlet weak var passEntry1: UITextField!
    @IBOutlet weak var passEntry2: UITextField!
    
    var username: String?
    var password: String?
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.username = userEntry?.text
        self.password = passEntry1?.text
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (userEntry?.text == "" || passEntry1?.text == "" || passEntry2?.text == "") {
            
            let alert = UIAlertController(title: "You need to enter all fields.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return false
        }
        else if (passEntry1?.text != passEntry2?.text) {
            let alert = UIAlertController(title: "Passwords do not match.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return false
        }
        else {
            return true
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
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

