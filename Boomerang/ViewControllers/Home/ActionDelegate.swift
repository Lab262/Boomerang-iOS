//
//  ActionDelegate.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


enum ActionType {
    case like
    case back
}

protocol ButtonActionDelegate{
    func actionButtonDelegate(actionType: ActionType?)
}
