//
//  Date+Utils.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation


extension Date {
    func getStringToDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from:self)
        return date
    }
}
