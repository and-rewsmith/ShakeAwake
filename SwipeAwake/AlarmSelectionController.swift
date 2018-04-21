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
        if let sourceViewController = sender.source as? SettingsController, let source_interval = sourceViewController.interval {
            self.alarmsHandler = AlarmsHandler(user: "TestUser", interval: source_interval)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsHandler!.alarms.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlarmTableViewCell
        
        cell.setFields(alarm: (self.alarmsHandler?.alarms[indexPath.row])!)
        
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

