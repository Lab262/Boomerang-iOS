//
//  TransactionMainViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionMainViewController: UIViewController {
    
    var segmentSelected: Int? {
        didSet {
            setFontButtonBySegmentSelected()
        }
    }
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    @IBOutlet weak var navigationBar: IconNavigationBar!
    
    @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loanTransactionButton: UIButton!
    @IBOutlet weak var exchangeTransactionButton: UIButton!
    @IBOutlet weak var donationTransactionButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        TabBarController.mainTabBarController.showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentSelected = 0
        navigationBar.leftButtonIcon.isHidden = true
        navigationBar.rightButton.addTarget(self, action: #selector(pushForDetailHistoric(_:)), for: .touchUpInside)
    }
    
    func pushForDetailHistoric(_ sender: UIButton) {
        
    }
    
    func setFontButtonBySegmentSelected(){
        switch segmentSelected! {
        case 0:
            loanTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
            loanTransactionButton.alpha = 1.0
            exchangeTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            exchangeTransactionButton.alpha = 0.56
            donationTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            donationTransactionButton.alpha = 0.56
            
        case 1:
            exchangeTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
            exchangeTransactionButton.alpha = 1.0
            loanTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            loanTransactionButton.alpha = 0.56
            donationTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            donationTransactionButton.alpha = 0.56
        case 2:
            donationTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
            donationTransactionButton.alpha = 1.0
            loanTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            loanTransactionButton.alpha = 0.56
            exchangeTransactionButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
            exchangeTransactionButton.alpha = 0.56
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? TransactionSegmentViewController {
            segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }
    }
    
    @IBAction func showLoanTransactions(_ sender: Any? = nil) {
        setSelectionIndication(true, center: false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    @IBAction func showExchangeTransactions(_ sender: Any? = nil) {
        setSelectionIndication(false, center: true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    @IBAction func showDonationTransaction(_ sender: Any? = nil) {
        setSelectionIndication(false, center: false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)
    }
    
    func setSelectionIndication(_ leading: Bool, center:Bool, trailing: Bool) {
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

extension TransactionMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            showLoanTransactions()
            segmentSelected = 0
        case 1:
            showExchangeTransactions()
            segmentSelected = 1
        case 2:
            showDonationTransaction()
            segmentSelected = 2
        default: break
        
        }
    }
}


