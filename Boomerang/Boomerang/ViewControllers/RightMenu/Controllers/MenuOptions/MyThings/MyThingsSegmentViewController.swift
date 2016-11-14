//
//  HistoricalReadingSegmentViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

protocol SegmentControlPageDelegate {
    func segmentScrolled(_ viewIndex: Int)
}

class MyThingsSegmentViewController: UIViewController {
    
    
    var previousPage: Int = 0
    var segmentControlPageDelegate : SegmentControlPageDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        self.scrollView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }

}

//Pragma MARK: - UIScrollViewDelegate
extension MyThingsSegmentViewController: UIScrollViewDelegate {
    
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
extension MyThingsSegmentViewController: SegmentControlButtonDelegate {
    
    func segmentSelected(_ viewIndex: Int) {
        
        var rectToScroll = self.view.frame
        rectToScroll.origin.x = self.view.frame.width * CGFloat(viewIndex)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: {
            self.scrollView.scrollRectToVisible(rectToScroll, animated: false)
            }, completion: nil)
    }
}
