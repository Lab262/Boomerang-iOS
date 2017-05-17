//
//  OtherActionsMainViewController..swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class OtherActionsMainViewController: UIViewController {
    
    var segmentSelected: Int? {
        didSet {
            setFontButtonBySegmentSelected()
        }
    }
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    
    @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var searchFriendsTransactionButton: UIButton!
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        TabBarController.mainTabBarController.showTabBar()
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
    }
    
    func popToRoot(_ notification : Notification){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setFontButtonBySegmentSelected(){
        switch segmentSelected! {
        case 0:
            notificationsButton.titleLabel?.font = UIFont.montserratBold(size: 16)
            notificationsButton.alpha = 1.0
            searchFriendsTransactionButton.titleLabel?.font = UIFont.montserratRegular(size: 16)
            searchFriendsTransactionButton.alpha = 0.56
        case 1:
            searchFriendsTransactionButton.titleLabel?.font = UIFont.montserratBold(size: 16)
            searchFriendsTransactionButton.alpha = 1.0
            notificationsButton.titleLabel?.font = UIFont.montserratRegular(size: 16)
            notificationsButton.alpha = 0.56
        default:
            break
        }
        configureDynamicsFonts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? OtherActionsSegmentViewController {
            segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }
    }

    @IBAction func showNotifications(_ sender: UIButton? = nil) {
        setSelectionIndication(true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    
    @IBAction func showSearchFriends(_ sender: UIButton? = nil) {
        setSelectionIndication(false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    func setSelectionIndication(_ leading: Bool, trailing: Bool) {
        viewLeftConstraint.isActive = false
        viewRightConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.viewLeftConstraint.isActive = leading
            self.viewRightConstraint.isActive = trailing
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension OtherActionsMainViewController: SegmentControlPageDelegate {
    
    
   // var notContainedStatusScheme: [StatusScheme] = [.done]
    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            showNotifications()
            segmentSelected = 0
        case 1:
            showSearchFriends()
            segmentSelected = 1
        default: break
            
        }
    }
}

