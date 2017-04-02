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
    @IBOutlet weak var imgViewLeftOption: UIImageView!
    @IBOutlet weak var imgViewCenterOption: UIImageView!
    @IBOutlet weak var imgViewRightOption: UIImageView!
    @IBOutlet weak var viewContainerCenterOption: UIView!
    static var mainTabBarController: TabBarController!
    
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var fifthButton: UIButton!
    
    var leftIsSelected: Bool = false {
        didSet {
            let stateImage = self.leftIsSelected ? UIImage() : #imageLiteral(resourceName: "ic_tabbar_boomer")
            self.imgViewLeftOption.image = stateImage
        }
    }
    
    var centerIsSelected: Bool = false {
        didSet {
            let stateImage = self.centerIsSelected ? #imageLiteral(resourceName: "ic_tabbar_boomer_selected") : #imageLiteral(resourceName: "ic_tabbar_boomer")
            self.imgViewCenterOption.image = stateImage
        }
    }
    
    var rightIsSelected: Bool = false {
        didSet {
            let stateImage = self.rightIsSelected ? UIImage() : UIImage(named: "ic_tabbar_boomer")
            self.imgViewRightOption.image = stateImage
        }
    }
    @IBAction func selectFirstOption(_ sender: UIButton) {
        
    }
   
    
    @IBAction func selectSecondOption(_ sender: UIButton) {
        
    }
    
    @IBAction func selectThirdOption(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func selectFourthOption(_ sender: UIButton) {
        
    }
    
    
    @IBAction func selectFifthOption(_ sender: UIButton) {
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
        
        self.viewContainerCenterOption.bouncingAnimation(false, duration: 0.01, delay: 0.0, completion: {(finished) in }, finalAlpha: 1.0, animationOptions: .curveEaseInOut)
        self.leftIsSelected = false
        self.rightIsSelected = false
        self.centerIsSelected = true
        self.uiTabBarController.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TabBarController.mainTabBarController = self
        // Do any additional setup after loading the view, typically from a nib.
        self.uiTabBarController.tabBar.isHidden = true
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let uiTabBarController = segue.destination as? UITabBarController {
            self.uiTabBarController = uiTabBarController
        }
    }
    
    static func showMenu() {
        let storyBoardToShow = UIStoryboard(name: "RightMenu", bundle: nil)
        let rightMenuNavController = storyBoardToShow.instantiateInitialViewController() as! UINavigationController
        
        TabBarController.mainTabBarController.present(rightMenuNavController, animated: true, completion: nil)

    }

     func removeTabBar() {
        self.imgViewLeftOption.isHidden = true
        self.imgViewRightOption.isHidden = true
        self.imgViewCenterOption.isHidden = true
        viewContainerCenterOption.isHidden = true
        tabBarController?.hidesBottomBarWhenPushed = true
        viewContainerTabBar.isHidden = true
        
    }

    func showTabBar() {
        self.imgViewLeftOption.isHidden = false
        self.imgViewRightOption.isHidden = false
        self.imgViewCenterOption.isHidden = false
        viewContainerCenterOption.isHidden = false
        tabBarController?.hidesBottomBarWhenPushed = false
        viewContainerTabBar.isHidden = false
        
    }

}

