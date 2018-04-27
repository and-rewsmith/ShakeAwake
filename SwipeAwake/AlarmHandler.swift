//
//  AlarmHandler.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/16/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import CoreData
import UIKit
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
    return times
}


class AlarmHandler {
    
    var ref = Database.database().reference()
    var user = ""
    var context: NSManagedObjectContext?
    var alarms: [Alarm]
    
    init(interval: Int, completionHandler: @escaping ()->Void) {
        self.alarms = [Alarm]()
        let times = populateTimes(interval: interval)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = (appDelegate?.persistentContainer.viewContext)!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "AlarmTime", in: context!)
        fetchRequest.entity = entityDescription
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmTime")
        request.returnsObjectsAsFaults = false
        
        var existingAlarms = [String]()
        
        do {
            let result = try context?.fetch(request)
            //   If the data exists in core data, append the time to the exists array
            for data in result as! [NSManagedObject] {
                if(data.value(forKey: "time") != nil){
                    existingAlarms.append(data.value(forKey: "time") as! String)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        for t in times {
            let alarm = Alarm(time: t, isSet: false)
            let time = existingAlarms.index(of: t)
            if time != nil {
                alarm.isSet = true
            }
            self.alarms.append(alarm)
        }
        
        if 24*60/interval == self.alarms.count {
            completionHandler()
        }
    }
    
    
    
    init(user: String, interval: Int, completionHandler: @escaping (Void)->Void){
    
        self.user = user
        self.alarms = [Alarm]()
        self.context = nil

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
    func turnOnAlarm(alarm: Alarm, usingCoreData: Bool) {
        alarm.isSet = true
        if usingCoreData{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "AlarmTime", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(alarm.time, forKey: "time")
            do {
                try context.save()
                //print(newUser.value(forKey: "time") as! String)
            } catch{
                print("CONTEXT SAVE FAILED")
            }
        }
        else {
            let userRef = self.ref.child(self.user)
            let timesRef = userRef.child("times")
            let timeRef = timesRef.child(alarm.time)
            timeRef.setValue(["status": alarm.isSet])
        }
    }
    
    
    //DEL from endpoint
    func turnOffAlarm(alarm: Alarm, usingCoreData: Bool) {
        alarm.isSet = false
        if usingCoreData{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmTime")
            request.predicate = NSPredicate(format: "time = %@", alarm.time)
            request.returnsObjectsAsFaults = false
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
                do {
                    try context.save()
                }
                catch {}
            }
            
        }
        else {
            let userRef = self.ref.child(self.user)
            let timesRef = userRef.child("times")
            let timeRef = timesRef.child(alarm.time)
            timeRef.removeValue()
        }
    }

}

