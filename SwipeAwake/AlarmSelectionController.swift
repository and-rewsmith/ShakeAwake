//
//  ViewController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/15/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class AlarmSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate {
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarmHandler: AlarmHandler?
    var username: String?
    var sound: String?
    var interval: Int?
    var sounds = ["By the Seaside" : "bts.mp3", "Tropical":"tropical.mp3", "Nokia":"nokia.mp3", "Fade":"fade.mp3", "Classical":"classic.mp3"]
    var player: AVAudioPlayer?
    var timers: [String: Timer] = [String: Timer]()
    lazy var motionManager = CMMotionManager()
    var audioRecorder: AVAudioRecorder?
    var usingCoreData: Bool?
    var nextVC: SettingsController?

    
    
    @IBAction func signOut(_ sender: Any) {
        
        let confirmationAlert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            for time in self.timers.keys {
                self.timers[time]?.invalidate()
                self.timers[time] = nil
            }
            self.performSegue(withIdentifier: "backupToLogin", sender: sender)
            self.player?.stop()
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToAlarmSelection(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsController, let source_interval = sourceViewController.interval, let source_username = sourceViewController.username, let source_sound = sourceViewController.sound, let source_usingCoreData = sourceViewController.usingCoreData {
            print(source_interval)
            self.username = source_username
            self.interval = source_interval
            if self.usingCoreData! {
                self.alarmHandler = AlarmHandler(interval: source_interval, completionHandler: {
                    DispatchQueue.main.async {
                        self.alarmTableView.reloadData()
                    }
                })
                print(self.alarmHandler?.alarms.count)
                self.sanitizeEnvironment()
            }
            else {
                self.alarmHandler = AlarmHandler(user: self.username!, interval: self.interval!, completionHandler: { () in
                    DispatchQueue.main.async {
                        self.alarmTableView.reloadData()
                    }
                })
                self.sanitizeEnvironment()
            }

            self.sound = source_sound
            self.usingCoreData = source_usingCoreData
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! SettingsController
            self.nextVC = destinationVC
            destinationVC.username = self.username
            destinationVC.interval = self.interval
            destinationVC.sound = self.sound
            destinationVC.usingCoreData = self.usingCoreData
            destinationVC.timers = self.timers
        }
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.alarmHandler != nil {
            return alarmHandler!.alarms.count
        }
        else {
            return 0
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlarmTableViewCell
        
        let alarm = self.alarmHandler?.alarms[indexPath.row]
        
        cell.onButtonTapped = {
            
            if (alarm?.isSet)! {
                print("turning off")
                if self.usingCoreData! {
                    self.alarmHandler?.turnOffAlarm(alarm: alarm!, usingCoreData: true)
                }
                else {
                    self.alarmHandler?.turnOffAlarm(alarm: alarm!, usingCoreData: false)
                }
            }
            else {
                print("turning on")
                if self.usingCoreData! {
                    self.alarmHandler?.turnOnAlarm(alarm: alarm!, usingCoreData: true)
                }
                else {
                    self.alarmHandler?.turnOnAlarm(alarm: alarm!, usingCoreData: false)
                }
            }
            
            self.trimDatasource()

            self.alarmTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        if (alarm?.isSet)! {
            var t = Timer()
            t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: alarm, repeats: true)
            
            self.timers[(alarm?.time)!]?.invalidate()
            self.timers[(alarm?.time)!] = nil
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
            if self.usingCoreData! {
                self.alarmHandler?.turnOffAlarm(alarm: alarm, usingCoreData: true)
            }
            else {
                self.alarmHandler?.turnOffAlarm(alarm: alarm, usingCoreData: false)
            }
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
            
            let topController = UIApplication.topViewController()
            
            let confirmationAlert: UIAlertController
            
            var should_reload: Bool?
            
            if topController is AlarmSelectionController {
                self.trimDatasource()
                should_reload = true
            }
            else {
                should_reload = false
            }
            
            confirmationAlert = UIAlertController(title: "Shake to Turn Off", message: "Click Ok then shake!", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                if should_reload! {
                    DispatchQueue.main.async {
                        self.alarmTableView.reloadData()
                    }
                }
            }))
            
            if self.nextVC != nil {
                self.nextVC?.player = self.player
            }
            
            topController?.present(confirmationAlert, animated: true, completion: nil)
        }
    }
    
    
    public func trimDatasource() {
        let cutoff = 24*60/self.interval!
        if let tmp = self.alarmHandler?.alarms[0..<cutoff] {
            let dummy: [Alarm] = Array(tmp)
            self.alarmHandler?.alarms = dummy
        }
    }
    
    func sanitizeEnvironment() {
        for alarm in (self.alarmHandler?.alarms)! {
            if alarm.isSet {
                let t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: alarm, repeats: true)
                self.timers[(alarm.time)]?.invalidate()
                self.timers[(alarm.time)] = nil
                self.timers[(alarm.time)] = t
            }
        }
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("turning off")
            self.player?.stop()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            print(self.interval)
            print(self.username)
        } else {
            print("Portrait")
            print(self.interval)
            print(self.username)
        }
        print()
    }
    
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
//    
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
//    }
//    
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return UIInterfaceOrientation.portrait
//    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        print("SHOULD ENTER SETUP")
        if !self.usingCoreData! {
            self.alarmHandler = AlarmHandler(user: self.username!, interval: self.interval!, completionHandler: { () in
                DispatchQueue.main.async {
                    self.alarmTableView.reloadData()
                }
            })
        }
        else {
            print("IN CORE DATA SETUP")
            //call core data init
            self.alarmHandler = AlarmHandler(interval: 5){
                DispatchQueue.main.async {
                    self.alarmTableView.reloadData()
                }
            }
        }
        
        self.sanitizeEnvironment()
        
        var tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        
        tempDirectoryURL.appendPathComponent("sleepRecording.ima4")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        do {
            try audioRecorder = AVAudioRecorder(url: tempDirectoryURL,
                                                settings: recordSettings as [String : AnyObject])
            self.audioRecorder?.prepareToRecord()
            self.audioRecorder?.record()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        // Force the device in portrait mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.alarmTableView.allowsSelection = false;
        AppUtility.lockOrientation(.portrait)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

