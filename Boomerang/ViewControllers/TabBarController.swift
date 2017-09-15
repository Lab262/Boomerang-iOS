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
    
    var inputConfigurationButtons = [(deselectedImage: #imageLiteral(resourceName: "tabbar_home_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_home_icon_selected"), selectIndex: 0), (deselectedImage: #imageLiteral(resourceName: "tabbar_profile_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_profile_icon_selected"), selectIndex: 1), (deselectedImage: #imageLiteral(resourceName: "tabbar_boomer_icon"), selectedImage: #imageLiteral(resourceName: "ic_boomerangWhite"), selectIndex: 2), (deselectedImage: #imageLiteral(resourceName: "tabbar_schemas_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_schemas_icon_selected"), selectIndex: 3), (deselectedImage: #imageLiteral(resourceName: "tabbar_notifications_icon"), selectedImage: #imageLiteral(resourceName: "tabbar_notifications_icon_selected"), selectIndex: 4)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.mainTabBarController = self
        self.uiTabBarController.tabBar.isHidden = true
        configureButtons()
    }
    
    func configureButtons(){
        for (index, button) in buttons.enumerated() {
            if button.tag != 2 {
                button.setImage(inputConfigurationButtons[index].deselectedImage, for: .normal)
                button.setImage(inputConfigurationButtons[index].selectedImage, for: .selected)
                button.tag = inputConfigurationButtons[index].selectIndex
            }
        }
        uiTabBarController.selectedIndex = 0
        buttons[0].isSelected = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let uiTabBarController = segue.destination as? UITabBarController {
            self.uiTabBarController = uiTabBarController
        }
    }
    
    func setupNotification(tabBarIndexView: Int) {
        switch tabBarIndexView {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.popToRootHome), object: nil, userInfo: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.popToRootProfile), object: nil, userInfo: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.popToRootBoomer), object: nil, userInfo: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.popToRootSchemes), object: nil, userInfo: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.popToRootOthers), object: nil, userInfo: nil)
        default: break
        }
    }

    @IBAction func selectButton(_ sender: UIButton) {
        
        changeStatesButtons(tag: sender.tag)
        
        if self.uiTabBarController.selectedIndex == sender.tag {
            self.setupNotification(tabBarIndexView: uiTabBarController.selectedIndex)
        }
        
        self.uiTabBarController.selectedIndex = sender.tag
    }
    
    func selectButtonPost(tag: Int){
        if tag == 2 {
            self.viewContainerCenterOption.bouncingAnimation(false, duration: 0.01, delay: 0.0, completion: {(finished) in }, finalAlpha: 1.0, animationOptions: .curveEaseInOut)
            self.imgViewCenterOption.image = #imageLiteral(resourceName: "ic_boomerangWhite")
            self.viewContainerCenterOption.backgroundColor = .yellowBoomerColor
        }else{
            self.imgViewCenterOption.image = #imageLiteral(resourceName: "tabbar_boomer_icon")
            self.viewContainerCenterOption.backgroundColor = .white
        }
    }
    
    func changeStatesButtons(tag: Int){
        
        selectButtonPost(tag: tag)
        
        for button in buttons {
            if button.tag != 2 {
                if button.tag == tag {
                    button.isSelected = true
                }else{
                    button.isSelected = false
                }
            }
        }
    }


    func hideTabBar() {
         self.viewContainerTabBar.isHidden = true
//        UIView.animate(withDuration: 0.3, animations: {
//            self.viewContainerTabBar.alpha = 0.0
//        }) { (success) in
//            self.viewContainerTabBar.isHidden = true
//        }
//    }
    }

    func showTabBar() {
        self.viewContainerTabBar.isHidden = false
//        UIView.animate(withDuration: 0.3, animations: {
//            self.viewContainerTabBar.isHidden = false
//            self.viewContainerTabBar.alpha = 1.0
//        }, completion: nil)

        
    }

}

