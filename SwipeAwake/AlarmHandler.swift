//
//  AlarmHandler.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/16/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


func populateTimes(interval: Int)->[String] {
    
    var times = [String]()
    var hour = 0
    var minute = 0
    
    while (hour < 24) {
        
        var str_hour: String
        var str_minute: String
        
        if (hour < 10) {
            str_hour = "0"+String(hour)
        }
        else {
            str_hour = String(hour)
        }
        
        if (minute < 10) {
            str_minute = "0"+String(minute)
        }
        else {
            str_minute = String(minute)
        }
        
        times.append(str_hour + ":" + str_minute)
        
        minute += interval
        
        if (minute >= 60) {
            hour += 1
            minute = minute % 60
        }
    }
    print(times)
    return times
}


class AlarmHandler {
    
    var ref = Database.database().reference()
    let user: String
    var alarms: [Alarm]
    
    
    init(user: String, interval: Int, completionHandler: @escaping (Void)->Void) {
        
        alarms = [Alarm]()
        
        self.user = user
        self.alarms = [Alarm]()
        
        let times = populateTimes(interval: interval)
                
        for t in times {
            
            let userRef = self.ref.child(self.user)
            let timesRef = userRef.child("times")
            timesRef.observe(.value, with: { (snapshot) in
                
                if snapshot.hasChild(t) {
                    
                    var isSet: Bool
                    
                    let timeSnapshot = snapshot.childSnapshot(forPath: t)
                    
                    //if model changes this must change
                    if let timeRef = timeSnapshot.value as! [String: Bool]? {
                        isSet = timeRef["status"]!
                    }
                    else {
                        print("FATAL ERROR: bools not stored correctly in firebase")
                        isSet = false
                    }
                    
                    let alarm = Alarm(time: t, isSet: isSet)
                    self.alarms.append(alarm)
                }
                else {
                    let alarm = Alarm(time: t, isSet: false)
                    self.alarms.append(alarm)
                }
                
                if 24*60/interval == self.alarms.count {
                    completionHandler()
                }

                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    //PUT to endpoint
    func turnOnAlarm(alarm: Alarm) {
        print("in turn on alarm")
        alarm.isSet = true
        let userRef = self.ref.child(self.user)
        let timesRef = userRef.child("times")
        let timeRef = timesRef.child(alarm.time)
        timeRef.setValue(["status": alarm.isSet]) //If the model changes this must update.
    }
    
    
    //DEL from endpoint
    func turnOffAlarm(alarm: Alarm) {
        alarm.isSet = false
        print("in turn off alarm")
        let userRef = self.ref.child(self.user)
        let timesRef = userRef.child("times")
        let timeRef = timesRef.child(alarm.time)
        timeRef.removeValue()
    }
    
}
