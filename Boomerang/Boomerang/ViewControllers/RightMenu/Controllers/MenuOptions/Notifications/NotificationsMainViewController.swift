//
//  NotificationsMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class NotificationsMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}
