//
//  ViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 10/7/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {

    @IBOutlet weak var viewContainerTabBar: UIView!
    var uiTabBarController: UITabBarController!
    @IBOutlet weak var imgViewCenterOption: UIImageView!
    @IBOutlet weak var viewContainerCenterOption: UIView!
    static var mainTabBarController: TabBarController!
    
    @IBOutlet var buttons: [UIButton]!
    
    var inputConfigurationButtons = [(deselectedImage: #imageLiteral(resourceName: "tabbar_home_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_home_icon_selected"), selectIndex: 0), (deselectedImage: #imageLiteral(resourceName: "tabbar_profile_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_profile_icon_selected"), selectIndex: 1), (deselectedImage: #imageLiteral(resourceName: "tabbar_boomer_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_boomer_icon"), selectIndex: 2), (deselectedImage: #imageLiteral(resourceName: "tabbar_schemas_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_schemas_icon_selected"), selectIndex: 3), (deselectedImage: #imageLiteral(resourceName: "tabbar_notifications_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_notifications_icon_selected"), selectIndex: 4)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.mainTabBarController = self
        self.uiTabBarController.tabBar.isHidden = true
        configureButtons()
    }
    
    func configureButtons(){
        for (index, button) in buttons.enumerated() {
            if index != 2 {
                button.setImage(inputConfigurationButtons[index].deselectedImage, for: .normal)
                button.setImage(inputConfigurationButtons[index].selectedImage, for: .selected)
            }
            
            button.tag = inputConfigurationButtons[index].selectIndex
        }
        
        
        
        uiTabBarController.selectedIndex = 0
        buttons[0].isSelected = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let uiTabBarController = segue.destination as? UITabBarController {
            self.uiTabBarController = uiTabBarController
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        for button in buttons {
            if button.tag == 2 {
                self.viewContainerCenterOption.bouncingAnimation(false, duration: 0.01, delay: 0.0, completion: {(finished) in }, finalAlpha: 1.0, animationOptions: .curveEaseInOut)
            } else {
                if button.tag == sender.tag {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
        }
        self.uiTabBarController.selectedIndex = sender.tag
    }


    func hideTabBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewContainerTabBar.alpha = 0.0
        }) { (success) in
            self.viewContainerTabBar.isHidden = true
        }
    }

    func showTabBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewContainerTabBar.isHidden = false
            self.viewContainerTabBar.alpha = 1.0
        }, completion: nil)

        
    }

}

