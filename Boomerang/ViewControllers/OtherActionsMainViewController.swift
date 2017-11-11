//
//  OtherActionsMainViewController..swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class OtherActionsMainViewController: UIViewController {
    
    var segmentSelected: Int? {
        didSet {
            setFontButtonBySegmentSelected()
        }
    }
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    
    @IBOutlet weak var viewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var searchFriendsTransactionButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        TabBarController.mainTabBarController.showTabBar()
        UIApplication.shared.applicationIconBadgeNumber = 0
        PFInstallation.current()?.badge = 0
        PFInstallation.current()?.saveEventually()
        TabBarController.mainTabBarController.configureBadgeNumber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentSelected = 0
        registerObservers()
    }
    
    func configureDynamicsFonts(){
        notificationsButton.titleLabel?.setDynamicFont()
        searchFriendsTransactionButton.titleLabel?.setDynamicFont()
    }
    
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot(_:)), name: NSNotification.Name(rawValue: NotificationKeys.popToRootOthers), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSearchFriends(_:)), name: NSNotification.Name(rawValue: NotificationKeys.selectSearchFriendsTab), object: nil)
    }
    
    func popToRoot(_ notification : Notification){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setFontButtonBySegmentSelected(){
        let buttons = [notificationsButton, searchFriendsTransactionButton, settingButton]
        
        for (i, button) in buttons.enumerated() {
            if i == segmentSelected {
                button!.titleLabel?.font = UIFont.montserratBold(size: 16)
                button!.alpha = 1.0
            } else {
                button!.titleLabel?.font = UIFont.montserratRegular(size: 16)
                button!.alpha = 0.5
            }
            button?.titleLabel?.setDynamicFont()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? OtherActionsSegmentViewController {
            segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }
    }

    @IBAction func showNotifications(_ sender: UIButton? = nil) {
        setSelectionIndication(true, false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    
    @IBAction func showSearchFriends(_ sender: UIButton? = nil) {
        setSelectionIndication(false, true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    @IBAction func showSettings(_ sender: Any? = nil) {
        setSelectionIndication(false, false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)
    
    }
    
    
    
    func setSelectionIndication(_ leading: Bool, _ center: Bool, trailing: Bool) {
        viewLeftConstraint.isActive = false
        viewCenterConstraint.isActive = false
        viewRightConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.viewLeftConstraint.isActive = leading
            self.viewCenterConstraint.isActive = center
            self.viewRightConstraint.isActive = trailing
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension OtherActionsMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            showNotifications()
            segmentSelected = 0
        case 1:
            showSearchFriends()
            segmentSelected = 1
        case 2:
            showSettings()
            segmentSelected = 2
        default: break
            
        }
    }
}

