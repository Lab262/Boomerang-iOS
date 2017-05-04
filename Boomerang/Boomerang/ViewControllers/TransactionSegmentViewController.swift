//
//  TransactionSegmentViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionSegmentViewController: UIViewController {
    
    var previousPage: Int = 0
    var segmentControlPageDelegate: SegmentControlPageDelegate?
    var presenter: TransactionPresenter = TransactionPresenter()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(view: self)
        presenter.getTransactions()

    }

}

//Pragma MARK: - UIScrollViewDelegate
extension TransactionSegmentViewController: UIScrollViewDelegate {
    
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
extension TransactionSegmentViewController: SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int) {
        var rectToScroll = self.view.frame
        rectToScroll.origin.x = self.view.frame.width * CGFloat(viewIndex)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: {
            self.scrollView.scrollRectToVisible(rectToScroll, animated: false)
        }, completion: nil)
    }
}


// MARK: - Presenter protocol
extension TransactionSegmentViewController: ViewDelegate {
    func reload() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.updateSchemes), object: presenter.getSchemes(), userInfo: nil)
    }
    func showMessageError(msg: String) {
        present(ViewUtil.alertControllerWithTitle(title: "Erro", withMessage: msg), animated: true, completion: nil)
    }
}


