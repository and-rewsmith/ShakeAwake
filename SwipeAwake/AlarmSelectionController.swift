//
//  ViewController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/15/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import UIKit

class AlarmSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //var user: String?
    //var sound: String?
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarmsHandler: AlarmsHandler?
    var username: String?
    var interval: Int?
    
    
    @IBAction func signOut(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
               self.performSegue(withIdentifier: "backupToLogin", sender: sender)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func unwindToAlarmSelection(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsController, let source_interval = sourceViewController.interval, let source_username = sourceViewController.username {
            print("IN UNWIND")
            self.username = source_username
            self.interval = source_interval
            self.alarmsHandler = AlarmsHandler(user: self.username!, interval: self.interval!)
            self.alarmTableView.reloadData()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backupToSelection" {
            let destinationVC = segue.destination as! AlarmSelectionController
            destinationVC.username = self.username
        }
        if segue.identifier == "Settings" {
            print("changing settings")
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! SettingsController
            destinationVC.username = self.username
        }
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsHandler!.alarms.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlarmTableViewCell
        
        let alarm = self.alarmsHandler?.alarms[indexPath.row]
        
        cell.onButtonTapped = {
            print(self.alarmsHandler?.alarms.count)
            if (alarm?.isSet)! {
                print("turning off")
                self.alarmsHandler?.turnOffAlarm(alarm: alarm!)
            }
            else {
                print("turning on")
                self.alarmsHandler?.turnOnAlarm(alarm: alarm!)
            }
            
            
            
            print(self.alarmsHandler?.alarms.count)
            //self.alarmTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            
            let cutoff = 24*60/self.interval!
            if let tmp = self.alarmsHandler?.alarms[0..<cutoff] {
                let dummy: [Alarm] = Array(tmp)
                self.alarmsHandler?.alarms = dummy
            }
            print(self.alarmsHandler?.alarms.count)

            self.alarmTableView.reloadRows(at: [indexPath], with: .automatic)
            //self.alarmTableView.reloadData()
        }
        
        if (alarm?.isSet)! {
            cell.setButton.backgroundColor = UIColor(red: 45/255, green: 252/255, blue: 173/255, alpha: 1)
        }
        else {
            cell.setButton.backgroundColor = UIColor.gray
        }
        
        cell.setFields(alarm: alarm!)
        
        
        return(cell)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.alarmTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.alarmTableView.reloadData()
        self.alarmTableView.allowsSelection = false;
        self.alarmTableView.isScrollEnabled = false;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.alarmTableView.reloadData()
        });
    }


}

