//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerMainViewController: UIViewController {


    @IBAction func showMenu(_ sender: Any) {
        
        TabBarController.showMenu()
    }
    
    @IBAction func iHaveAction(_ sender: Any) {
    }
    
    
    @IBAction func iNeedaction(_ sender: Any) {
    }
    
    @IBAction func donateAction(_ sender: Any) {
    }
    
    
    @IBAction func experienceAction(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
}
