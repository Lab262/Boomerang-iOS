//
//  DefaultsHelper.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

enum DefaultDataType: String {
    case Email = "email",
    Password = "password"
}

class DefaultsHelper: NSObject {

    static let sharedInstance = DefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    var email: String? {
        get {
            return userDefaults.string(forKey: DefaultDataType.Email.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: DefaultDataType.Email.rawValue)
        }
    }
    
    var password: String? {
        get {
            return userDefaults.string(forKey: DefaultDataType.Password.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: DefaultDataType.Password.rawValue)
        }
    }

    func deleteAllValues() {
        for key in Array(userDefaults.dictionaryRepresentation().keys) {
            if key != DefaultDataType.Email.rawValue {
                userDefaults.removeObject(forKey: key)
            }
        }
        userDefaults.synchronize()
    }

}
