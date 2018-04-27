//
//  signupController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/19/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class RegistrationController: UIViewController {
    
    @IBOutlet weak var userEntry: UITextField!
    @IBOutlet weak var passEntry1: UITextField!
    @IBOutlet weak var passEntry2: UITextField!
    
    var username: String?
    var password: String?
    var ref: DatabaseReference?

    
    @IBAction func register(_ sender: Any) {
        
        self.userEntry.text = self.userEntry.text?.lowercased()
        
        if (self.userEntry?.text == "" || self.passEntry1?.text == "" || self.passEntry2?.text == "") {
            
            let alert = UIAlertController(title: "You need to enter all fields.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        else if (self.passEntry1?.text != self.passEntry2?.text) {
            let alert = UIAlertController(title: "Passwords do not match.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        else {
            
            isUsernameTaken(candidate: self.userEntry.text!, completionHandler2: { (out: Bool) in
                if out {
                    self.performSegue(withIdentifier: "backupToLogin2", sender: sender)
                }
                else {
                    let alert = UIAlertController(title: "Username taken.", message: "", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                }
            })
            
            
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.username = self.userEntry?.text
        self.password = MD5((self.passEntry1?.text)!)
    }
    
    
    func isUsernameTaken(candidate: String, completionHandler2: @escaping (Bool)->()) {
        
        self.ref?.observe(.value, with: { (snapshot) in
            if snapshot.hasChild(candidate) {
                completionHandler2(false)
            }
            else {
                completionHandler2(true)    
            }
        })
        
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

}

