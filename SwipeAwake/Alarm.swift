//
//  Alarm.swift
//  SwipeAwake
//
//  Created by Andrew Smith on 4/16/18.
//  Copyright © 2018 Andrew Smith. All rights reserved.
//

import Foundation

//We are going to need to add a lot to this model
class Alarm {

    var time: String
    var isSet: Bool
    
    init(time: String, isSet: Bool) {
        self.time = time
        self.isSet = isSet
    }
    
}
