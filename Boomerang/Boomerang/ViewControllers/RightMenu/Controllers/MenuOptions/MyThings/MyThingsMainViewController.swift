//
//  HistoricalReadingMainViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


protocol SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int)
}

class MyThingsMainViewController: UIViewController {
    
    @IBOutlet weak var lendingThingsButton: UIButton!
    @IBOutlet weak var requestedThingsButton: UIButton!
    @IBOutlet weak var experienceThingsButton: UIButton!

    var segmentSelected: Int?
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    
    @IBOutlet weak var lendingThingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestedThingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var experienceThingsSelectionBarCenterConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.segmentSelected = 0
        self.segmentScrolled(0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segmentVC = segue.destination as? MyThingsSegmentViewController {
            self.segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }
    }
  
    @IBAction func showLendingThings(_ sender: AnyObject? = nil) {
        setSelectionIndication(true, center: false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
        
    }
    
    @IBAction func showRequestedThings(_ sender: AnyObject? = nil) {
        setSelectionIndication(false, center: true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    
    @IBAction func showExperienceThings(_ sender: AnyObject? = nil) {
        setSelectionIndication(false, center: false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)
    }
    
    func setSelectionIndication(_ leading: Bool, center:Bool, trailing: Bool) {
        self.lendingThingsSelectionBarCenterConstraint.isActive = false
        self.requestedThingsSelectionBarCenterConstraint.isActive = false
        self.experienceThingsSelectionBarCenterConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.lendingThingsSelectionBarCenterConstraint.isActive = leading
            self.requestedThingsSelectionBarCenterConstraint.isActive = center
            self.experienceThingsSelectionBarCenterConstraint.isActive = trailing
            self.view.layoutIfNeeded()
        }, completion: nil)
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

extension MyThingsMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            showLendingThings()
            self.lendingThingsButton.setTitleColor(UIColor.selectedButtonTextColor, for: .normal)
            self.requestedThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            self.experienceThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            self.segmentSelected = 0
            
            break
        case 1:
            showRequestedThings()
            self.segmentSelected = 1
            self.lendingThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            self.requestedThingsButton.setTitleColor(UIColor.selectedButtonTextColor, for: .normal)
            self.experienceThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            break
        case 2:
            showExperienceThings()
            self.segmentSelected = 2
            self.lendingThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            self.requestedThingsButton.setTitleColor(UIColor.unselectedButtonTextColor, for: .normal)
            self.experienceThingsButton.setTitleColor(UIColor.selectedButtonTextColor, for: .normal)
            break
        default: break
            
        }
    }
    
}

