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
    let sounds = ["By the Seaside", "Sound 2"]
    
    var interval: Int?
    var sound: String?
    var username: String?
    
    
    // This method lets you configure a view controller before it's presented.
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
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == intervalPicker {
//            print(intervals[row])
//        }
//        else if pickerView == soundPicker {
//            print(sounds[row])
//        }
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColorFromHex(rgbValue:0x795791, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
        
        soundPicker.delegate = self
        soundPicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
