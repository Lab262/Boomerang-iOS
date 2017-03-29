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
    
    func getDayAndMonthToDate() -> String {
        let calendar = Calendar.current
        
//        let year = calendar.component(.year, from: self)
//        let month = calendar.component(.month, from: self)
//        let day = calendar.component(.day, from: self)
        //mo
        
        return ""
    }
    
    func getFormatterDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withDay, .withDashSeparatorInDate, .withMonth]
        
        let date = formatter.string(from: self)
        
        return date
    }
    
//    static let iso8601Formatter: ISO8601DateFormatter = {
//        let formatter = ISO8601DateFormatter()
//        let date = formatter.string(from: self)
//        formatter.formatOptions = [.withFullDate,
//                                   .withTime,
//                                   .withDashSeparatorInDate,
//                                   .withColonSeparatorInTime,
//                                    ]
//        
//        return formatter
//    }()
    
   // func getMonth
}
