//
//  LogInController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/15/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var soundPicker: UIPickerView!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    let intervals = [1, 2, 3, 4, 5, 10, 15]
    let sounds = ["By the Seaside", "Fade", "Classical", "Tropical", "Nokia"]
    
    var interval: Int?
    var sound: String?
    var username: String?
    var usingCoreData: Bool?
    
    
    @IBAction func saveSettings(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Save Settings?", message: "Alarms not in the selected interval will no longer be active.", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "backupToSelection", sender: sender)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.interval = intervals[intervalPicker.selectedRow(inComponent: 0)]
        self.sound = sounds[soundPicker.selectedRow(inComponent: 0)]
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == intervalPicker {
            return intervals.count
        }
        
        else if pickerView == soundPicker {
            return sounds.count
        }
        
        else {
            return 0
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if pickerView == intervalPicker {
            let interval = String(intervals[row])
            
            let myTitle = NSAttributedString(string: interval, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            
            return myTitle
        }
        else {
            let sound = sounds[row]
            
            let myTitle = NSAttributedString(string: sound, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            
            return myTitle
            
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.intervalPicker.delegate = self
        self.intervalPicker.dataSource = self
        
        self.soundPicker.delegate = self
        self.soundPicker.dataSource = self
        
        var index = 0
        for entry in self.intervals {
            if entry == self.interval {
                break
            }
            index += 1
        }
        self.intervalPicker.selectRow(index, inComponent: 0, animated: true)
        
        index = 0
        for entry in self.sounds {
            if entry == self.sound {
                break
            }
            index += 1
        }
        self.soundPicker.selectRow(index, inComponent: 0, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

