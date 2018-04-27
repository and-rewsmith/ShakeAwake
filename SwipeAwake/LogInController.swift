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
    
    @IBOutlet weak var passEntry: UITextField!
    @IBOutlet weak var userEntry: UITextField!
    
    var ref: DatabaseReference?

    
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
            destinationVC.sound = "By the Seaside"
            destinationVC.usingCoreData = false
            //print("TRIGGERING LOGIN SEGUE")
        }
        
        if segue.identifier == "Skip" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AlarmSelectionController
            destinationVC.username = ""
            destinationVC.interval = 5
            destinationVC.sound = "By the Seaside"
            destinationVC.usingCoreData = true
        }
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        ref = Database.database().reference()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
}

