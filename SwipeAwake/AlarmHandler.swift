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


class AlarmHandler {
    
    var dates: [String]
    
    init(interval: Int) {
        
        dates = [String]()
        
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
            
            dates.append(str_hour + ":" + str_minute)
            
            minute += interval
            
            if (minute >= 60) {
                hour += 1
                minute = minute % 60
            }
        }
        
    }
    
    
    //PUT to endpoint
    func turnOnAlarm(time: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let date = ref.child(time)
        date.setValue([]) //We will decide on the model later.
        
        
    }
    
    //DEL from endpoint
    func turnOffAlarm(time: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let date = ref.child(time)
        date.removeValue()
    }
    
    
    
    
}
