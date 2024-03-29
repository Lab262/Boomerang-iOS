//
//  OtherActionsSegmentViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class OtherActionsSegmentViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var previousPage: Int = 0
    var segmentControlPageDelegate: SegmentControlPageDelegate?
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter.setViewDelegate(view: self)
//        presenter.getTransactions()
        
    }
}

//Pragma MARK: - UIScrollViewDelegate
extension OtherActionsSegmentViewController: UIScrollViewDelegate {
    
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
extension OtherActionsSegmentViewController: SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int) {
        var rectToScroll = self.view.frame
        rectToScroll.origin.x = self.view.frame.width * CGFloat(viewIndex)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: {
            self.scrollView.scrollRectToVisible(rectToScroll, animated: false)
        }, completion: nil)
    }
}

