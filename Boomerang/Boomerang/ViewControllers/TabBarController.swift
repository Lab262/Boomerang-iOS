//
//  ViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 10/7/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {

    var uiTabBarController: UITabBarController!
    @IBOutlet weak var imgViewLeftOption: UIImageView!
    @IBOutlet weak var imgViewCenterOption: UIImageView!
    @IBOutlet weak var imgViewRightOption: UIImageView!

    var leftIsSelected: Bool = false {
        didSet {
            let stateImage = self.leftIsSelected ? UIImage() : UIImage(named: "ic_tabbar_boomer")
            self.imgViewLeftOption.image = stateImage
        }
    }
    
    var centerIsSelected: Bool = false {
        didSet {
            let stateImage = self.centerIsSelected ? UIImage() : UIImage(named: "ic_tabbar_boomer")
            self.imgViewCenterOption.image = stateImage
        }
    }
    
    var rightIsSelected: Bool = false {
        didSet {
            let stateImage = self.rightIsSelected ? UIImage() : UIImage(named: "ic_tabbar_boomer")
            self.imgViewRightOption.image = stateImage
        }
    }
    
    @IBAction func selectLeftOption(_ sender: UIButton) {
        
        self.leftIsSelected = true
        self.rightIsSelected = false
        self.centerIsSelected = false
        self.uiTabBarController.selectedIndex = 0
    }
    
    @IBAction func selectRightOption(_ sender: UIButton) {
        
        self.leftIsSelected = false
        self.rightIsSelected = true
        self.centerIsSelected = false
        self.uiTabBarController.selectedIndex = 2

    }
    
    @IBAction func selectCenterOption(_ sender: UIButton) {
        
        self.leftIsSelected = false
        self.rightIsSelected = false
        self.centerIsSelected = true
        self.uiTabBarController.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.uiTabBarController.tabBar.isHidden = true
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let uiTabBarController = segue.destination as? UITabBarController {
            self.uiTabBarController = uiTabBarController
        }
    }

}

