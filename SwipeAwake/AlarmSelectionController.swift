//
//  ViewController.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/15/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import UIKit

class AlarmSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var alarmView: UITableView!
    
    
    //Ignore weak warning for now. It will mutate.
    //TODO: Get user from login segue
    var alarmsHandler = AlarmsHandler(user: "TestUser",interval: 15)

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsHandler.alarms.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlarmTableViewCell
        
        cell.setFields(alarm: self.alarmsHandler.alarms[indexPath.row])
        
        return(cell)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

