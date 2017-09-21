//
//  TransactionSegmentViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchThingsSegmentViewController: UIViewController {
    
    var previousPage: Int = 0
    var segmentControlPageDelegate: SegmentControlPageDelegate?
    var presenter: TransactionPresenter = TransactionPresenter()
    var notificationKey: String!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        setupViewDelegate()
        getTransactions()
        setupSubscriptions()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    func getTransactions(){
        presenter.getTransactions()
    }
    
    func setupSubscriptions(){
        presenter.setupSubscriptions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LoanTransactionViewController {
            vc.notificationKey = notificationKey
        }
        
        if let vc = segue.destination as? ExchangeTransactionViewController {
            vc.notificationKey = notificationKey
        }
        
        if let vc = segue.destination as? DonationTransactionViewController {
            vc.notificationKey = notificationKey
        }
    }
}

//Pragma MARK: - UIScrollViewDelegate
extension SearchThingsSegmentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setupPage()
    }
    
    func setupPage(){
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage: CGFloat = scrollView.contentOffset.x / pageWidth
        let page: Int = lround(Double(fractionalPage))
        if previousPage != page {
            segmentControlPageDelegate?.segmentScrolled(page)
            previousPage = page
        }
    }
}

//Pragma MARK: - SegmentControlButtonDelegate
extension SearchThingsSegmentViewController: SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int) {
        var rectToScroll = self.view.frame
        rectToScroll.origin.x = self.view.frame.width * CGFloat(viewIndex)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: {
            self.scrollView.scrollRectToVisible(rectToScroll, animated: false)
        }, completion: nil)
    }
}


// MARK: - Presenter protocol
extension SearchThingsSegmentViewController: ViewDelegate {
    
    func reload() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: presenter.schemes, userInfo: nil)
    }
    
    func showMessageError(msg: String) {
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: msg, negativeAction: "Ok") { (isPositive) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}


