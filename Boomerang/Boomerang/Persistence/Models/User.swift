//
//  User.swift
//  Boomerang
//
//  Created by Felipe perius on 11/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//


import FalconFrameworkIOSSDK


class User: FFModel {
    
    var name: String? = ""
    var email: String? = ""
    var password: String? = ""
    var cpf: String? = ""
    var accessLevel: Int? = 0
    var gender: Int? = 0

}
