//
//  TimeDialogViewController.swift
//  Tavie
//
//  Created by Ahmed Taha Aroua on 15/07/2016.
//  Copyright © 2016 360medlink. All rights reserved.
//

import UIKit

class GenericBoomerAlertController: UIViewController {
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var viewCont: UIView!
    @IBOutlet weak var positiveActionLbl: UILabel!
    @IBOutlet weak var negativeActionLbl: UILabel!
    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var positiveButtonView: UIView!

    var alertActionBlock: (_ isPositiveAnswer: Bool) -> Void = { ok in }
    var alertInfo: (message: String, positiveActionTitle: String? , negativeActionTitle: String) = (message: "", positiveActionTitle: "", negativeActionTitle: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerYConstraint.constant = self.view.frame.size.height
        self.alertTitleLbl.text = self.alertInfo.message
        self.positiveActionLbl.text = self.alertInfo.positiveActionTitle
        self.negativeActionLbl.text = self.alertInfo.negativeActionTitle

        if let positiveActionLbl = self.alertInfo.positiveActionTitle {
            self.positiveActionLbl.text = positiveActionLbl
//            self.positiveButtonView.
        } else {
            self.positiveActionLbl.removeFromSuperview()
        }
    }
    
    @IBAction func selectPositiveAction(_ sender: Any) {
        self.alertActionBlock(true)
        self.dismissViewAnimation()
    }

    @IBAction func selectNegativeAction(_ sender: Any) {
        self.alertActionBlock(false)
        self.dismissViewAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showViewAnimation()
    }

    public class func presentMe(inParent vc: UIViewController, withTitle title:String, positiveAction positiveTitle: String? = nil, negativeAction negativeTitle: String, alertActionBlock: @escaping (_ isPositiveAnswer: Bool) -> Void ) {
        
        let boomerAlert = GenericBoomerAlertController()
        boomerAlert.alertActionBlock = alertActionBlock
        boomerAlert.alertInfo.message = title
        boomerAlert.alertInfo.positiveActionTitle = positiveTitle
        boomerAlert.alertInfo.negativeActionTitle = negativeTitle

        boomerAlert.modalPresentationStyle = .overCurrentContext
        boomerAlert.view.backgroundColor = .clear
        vc.present(boomerAlert, animated: false, completion: nil)
    }

}

//Pragma MARK: - PopUp Animation
extension GenericBoomerAlertController {
    
    func showViewAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.centerYConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }) 
    }
    
    func dismissViewAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options:.curveEaseOut, animations: {
            self.centerYConstraint.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0.0
            }, completion: { (finished) in
                self.dismiss(animated: false, completion:nil)
        })
    }
}
