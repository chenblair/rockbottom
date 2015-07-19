//
//  Story.swift
//  Rock Bottom
//
//  Created by Jerry Chen on 7/18/15.
//  Copyright (c) 2015 Jerry Chen. All rights reserved.
//

import UIKit
import Foundation

class Story: NSObject
{
    var storyText: String
    var shittiness: Int
    
    var identifier: String
    
    init(storyText: String, shittiness: Int)
    {
        self.storyText = storyText
        self.shittiness = shittiness
    
        var device = UIDevice.currentDevice()
        
        identifier = device.identifierForVendor.UUIDString
    }
    
}
