//
//  TransactionMainViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchThingsMainViewController: UIViewController {
    
    var segmentSelected: Int? {
        didSet {
            setFontButtonBySegmentSelected()
        }
    }
    
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?
    var segmentVC: SearchThingsSegmentViewController?

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var navigationBar: IconNavigationBar!
    @IBOutlet weak var allTransactionButton: UIButton!
    @IBOutlet weak var loanTransactionButton: UIButton!
    @IBOutlet weak var exchangeTransactionButton: UIButton!
    @IBOutlet weak var donationTransactionButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentSelected = 0
        self.setupNavigationActions()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: NSNotification.Name(rawValue: "dismissKeyboard"), object: nil)
    }

    func setupNavigationActions() {
        navigationBar.leftButtonIcon.isHidden = false
        navigationBar.leftButton.isHidden = false
        navigationBar.rightButton.isHidden = true
        navigationBar.rightIcon.isHidden = true
        navigationBar.leftButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
    }

    func popToRoot(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setFontButtonBySegmentSelected(){
        let buttons = [allTransactionButton, loanTransactionButton, exchangeTransactionButton, donationTransactionButton]
        
        for (i, button) in buttons.enumerated() {
            if i == segmentSelected {
                button!.titleLabel?.font = UIFont.montserratBold(size: 16)
                button!.alpha = 1.0
            } else {
                button!.titleLabel?.font = UIFont.montserratRegular(size: 16)
                button!.alpha = 0.5
            }
            button!.titleLabel?.setDynamicFont()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? SearchThingsSegmentViewController {
            segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
            self.segmentVC = segmentVC
        }
    }
    
    
    @IBAction func showAllTransactions(_ sender: Any? = nil) {
        setSelectionIndication(inButton: self.allTransactionButton)
        segmentControlButtonDelegate?.segmentSelected(0)
        self.segmentVC?.searchDelegate?.didSearch(scope: .all, searchString: searchBar.text!)
    }
    
    @IBAction func showLoanTransactions(_ sender: Any? = nil) {
        setSelectionIndication(inButton: self.loanTransactionButton)
        segmentControlButtonDelegate?.segmentSelected(1)
        self.segmentVC?.searchDelegate?.didSearch(scope: .have, searchString: searchBar.text!)
    }
    
    @IBAction func showExchangeTransactions(_ sender: Any? = nil) {
        setSelectionIndication(inButton: self.exchangeTransactionButton)
        segmentControlButtonDelegate?.segmentSelected(2)
        self.segmentVC?.searchDelegate?.didSearch(scope: .need, searchString: searchBar.text!)
    }

    @IBAction func showDonationTransaction(_ sender: Any? = nil) {
        setSelectionIndication(inButton: self.donationTransactionButton)
        segmentControlButtonDelegate?.segmentSelected(3)
        self.segmentVC?.searchDelegate?.didSearch(scope: .donate, searchString: searchBar.text!)
    }

    func setSelectionIndication(inButton button: UIButton?) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            if let xPosition = button?.layer.position.x {
                self.selectionView.layer.position.x = xPosition
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension SearchThingsMainViewController: SegmentControlPageDelegate {

    func segmentScrolled(_ viewIndex: Int) {
        switch viewIndex {
        case 0:
            showAllTransactions()
            segmentSelected = 0
        case 1:
            showLoanTransactions()
            segmentSelected = 1
        case 2:
            showExchangeTransactions()
            segmentSelected = 2
        case 3:
            showDonationTransaction()
            segmentSelected = 3
        default: break
        
        }
    }
}

extension SearchThingsMainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scope = TypePostEnum.atIndex(self.segmentVC!.previousPage)
        self.segmentVC!.searchDelegate!.didSearch(scope: scope, searchString: searchBar.text!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

}


