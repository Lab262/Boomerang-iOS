//
//  Date+Utils.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func getStringToDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from:self)
        return date
    }
    
    func timeSinceNow() -> String {
        let calender:Calendar = Calendar.current
        let components:DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        var timeAgo: String = ""
        
        if components.year! == 1 {
            timeAgo = "\(components.year!)" + TimeAgo.oneYear
        } else if components.year! > 1 {
            timeAgo = "\(components.year!)" + TimeAgo.year
        } else if components.month! == 1 {
            timeAgo = "\(components.month!)" + TimeAgo.oneMonth
        } else if components.month! > 1 {
            timeAgo = "\(components.month!)" + TimeAgo.month
        } else if components.day! == 1 {
            timeAgo = "\(components.day!)" + TimeAgo.oneDay
        } else if components.day! > 1 {
            timeAgo = "\(components.day!)" + TimeAgo.day
        } else if components.hour! == 1 {
            timeAgo = "\(components.hour!)" + TimeAgo.oneHour
        } else if components.hour! > 1 {
            timeAgo = "\(components.hour!)" + TimeAgo.hour
        } else if components.minute! == 1 {
            timeAgo = "\(components.minute!)" + TimeAgo.oneMin
        } else if components.minute! > 1 {
            timeAgo = "\(components.minute!)" + TimeAgo.min
        } else if components.second! < 60 {
            timeAgo = TimeAgo.now
        }
        
        return timeAgo
    }
    
}
