//
//  FeedbackConfirmationViewController.swift
//  Boomerang
//
//  Created by Felipe perius on 26/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class FeedbackConfirmationViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var viewDetailHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
    }
    
    func configureLabels(){
        messageLabel.setDynamicFont()
        messageLabel.attributedText = messageLabel.text?.with(characterSpacing: 1.0, lineSpacing: 2.0, alignment: .center, color: .feedbackTextLabelColor)
        acceptButton.titleLabel?.setDynamicFont()
        acceptButton.titleLabel?.attributedText = acceptButton.titleLabel?.text?.with(characterSpacing: 1.3, color: .unselectedTextButtonColor)
        //iPhone X
        if UIScreen.main.bounds.height >= 812.0 {
            viewDetailHeightConstraint.constant = 45.0
        }
    }

    @IBAction func clickButton(_ sender: Any) {
        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
    }

}
