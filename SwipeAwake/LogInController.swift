//
//  LogInController.swift
//  SwipeAwake
//
//  Created by Rossi McCall on 4/15/18.
//  Copyright © 2018 Rossi McCall and Andrew Smith. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class LogInController: UIViewController {
    
    var ref: DatabaseReference?

    @IBOutlet weak var passEntry: UITextField!
    
    @IBOutlet weak var userEntry: UITextField!
    
    
    @IBAction func login(_ sender: Any) {
        
        self.userEntry.text = self.userEntry.text?.lowercased()
        
        authenticate(completionHandler: { (out:Bool) in
            if out {
                self.performSegue(withIdentifier: "Login", sender: sender)
            }
        })
    }
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RegistrationController, let username = sourceViewController.username, let password = sourceViewController.password {

            userEntry.text = username
            
            let userRef = self.ref?.child(username)
            let passRef = userRef?.child("password")
            passRef?.setValue(password)
        }
        
        else if sender.source is AlarmSelectionController {
            self.passEntry.text = ""
        }
    }
    
    func authenticate(completionHandler:@escaping  (Bool) -> Void) {
        
        if userEntry.text == "" || passEntry.text == "" {
            let alert = UIAlertController(title: "You must enter login information.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            completionHandler(false)
        }
        
        else {
            self.ref?.observe(.value, with: { (snapshot) in
                if snapshot.hasChild(self.userEntry.text!) {
                    
                    let userSnapshot = snapshot.childSnapshot(forPath: self.userEntry.text!)
                    
                    let passSnapshot = userSnapshot.childSnapshot(forPath: "password")
                    
                    let pass = passSnapshot.value as! String
                    
                    if pass == MD5(self.passEntry.text!)! {
                        completionHandler(true)
                    }
                    else {
                        let alert = UIAlertController(title: "Incorrect login information.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        completionHandler(false)
                    }
                }
                else {
                    let alert = UIAlertController(title: "Username is not in our system", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    completionHandler(false)
                }
            }) { (error) in
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AlarmSelectionController
            destinationVC.username = self.userEntry.text!
            destinationVC.interval = 5
        }
        
        if segue.identifier == "Skip" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AlarmSelectionController
            destinationVC.username = "xzhfbqjwejzakl"
            destinationVC.interval = 5
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
//        let alarmsHandler = AlarmsHandler(user: "TestUser", interval: 15)
//        let alarm1 = Alarm(time: "02:30", isSet: true)
//        alarmsHandler.turnOnAlarm(alarm: alarm1)
        
        
        
        ref = Database.database().reference()
        
//        let ah = AlarmsHandler(user:"test", interval: 15)
//        print(ah.alarms.count)
//        let alarm = ah.alarms[0]
//        ah.turnOnAlarm(alarm: alarm)
//        print(ah.alarms.count)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

