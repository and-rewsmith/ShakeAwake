//
//  ViewController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/15/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarmHandler: AlarmHandler?
    var username: String?
    var sound: String?
    var interval: Int?
    var sounds = ["By the Seaside" : "bts.mp3", "Tropical":"tropical.mp3", "Nokia":"nokia.mp3", "Fade":"fade.mp3", "Classic":"classic.mp3"]
    var player: AVAudioPlayer?
    var timers: [String: Timer] = [String: Timer]()
    
    
    @IBAction func signOut(_ sender: Any) {
        
        let confirmationAlert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            for time in self.timers.keys {
                self.timers[time]?.invalidate()
                self.timers[time] = nil
            }
               self.performSegue(withIdentifier: "backupToLogin", sender: sender)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToAlarmSelection(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsController, let source_interval = sourceViewController.interval, let source_username = sourceViewController.username, let source_sound = sourceViewController.sound {
            print(source_interval)
            self.username = source_username
            self.interval = source_interval
            self.alarmHandler = AlarmHandler(user: self.username!, interval: self.interval!, completionHandler: { () in
                self.alarmTableView.reloadData()
            })
            self.sound = source_sound
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
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! SettingsController
            destinationVC.username = self.username
            destinationVC.interval = self.interval
            destinationVC.sound = self.sound
            for time in self.timers.keys {
                self.timers[time]?.invalidate()
                self.timers[time] = nil
            }
        }
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmHandler!.alarms.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlarmTableViewCell
        
        let alarm = self.alarmHandler?.alarms[indexPath.row]
        
        
        cell.onButtonTapped = {
            
            print(alarm?.isSet)
            
            if (alarm?.isSet)! {
                print("turning off")
                self.alarmHandler?.turnOffAlarm(alarm: alarm!)
            }
            else {
                print("turning on")
                self.alarmHandler?.turnOnAlarm(alarm: alarm!)
            }
            
            print(alarm?.isSet)
            
            self.trimDatasource()

            self.alarmTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if (alarm?.isSet)! {
            var t = Timer()
            t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: alarm, repeats: true)
            
            self.timers[(alarm?.time)!] = t
        }
        else {
            self.timers[(alarm?.time)!]?.invalidate()
            self.timers[(alarm?.time)!] = nil
            self.timers.removeValue(forKey: (alarm?.time)!)
        }
        
        cell.setFields(alarm: alarm!)
        
        
        return(cell)
    }
    
    
    func updateTimer(timer: Timer) {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var minutes_str: String
        var hour_str: String
        if String(minutes).characters.count == 1 {
            minutes_str = "0" + String(minutes)
        }
        else {
            minutes_str = String(minutes)
        }
        if String(hour).characters.count == 1 {
            hour_str = "0" + String(hour)
        }
        else {
            hour_str = String(hour)
        }
        
        let cmp = String(hour_str) + ":" + String(minutes_str)
        
        let alarm = timer.userInfo as! Alarm
        
        print(cmp)
        print(alarm.time)
        print(alarm.isSet)
        print()
        
        if cmp == alarm.time && alarm.isSet {
            self.alarmHandler?.turnOffAlarm(alarm: alarm)
            self.timers[alarm.time]?.invalidate()
            self.timers[alarm.time] = nil
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch let error as NSError {
                print("setCategory error: \(error.localizedDescription)")
            }
            do {
                try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            }
            catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
            
            let resource = self.sounds[sound!]
            
            let path = Bundle.main.path(forResource: resource, ofType: nil)!
            
            let url = URL(fileURLWithPath: path)
            
            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player?.numberOfLoops = -1
                self.player?.prepareToPlay()
                self.player?.play()
            } catch {
                print("Couldn't play sound!")
            }
            
            self.trimDatasource()
            self.alarmTableView.reloadData()
            
            let confirmationAlert = UIAlertController(title: "Turn Off Alarm?", message: "Turn off alarm by clicking OK.", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.player?.stop()
            }))
            
            self.present(confirmationAlert, animated: true, completion: nil)
            
        }
        
        // else if triggered and alarm not set listen for shake to kill sound
        
        
    }
    
    
    public func trimDatasource() {
        let cutoff = 24*60/self.interval!
        if let tmp = self.alarmHandler?.alarms[0..<cutoff] {
            let dummy: [Alarm] = Array(tmp)
            self.alarmHandler?.alarms = dummy
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        
        self.alarmHandler = AlarmHandler(user: self.username!, interval: self.interval!, completionHandler: { () in
            self.alarmTableView.reloadData()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.alarmTableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //self.alarmTableView.reloadData()
        self.alarmTableView.allowsSelection = false;
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

