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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
    }
    
    func configureLabels(){
        messageLabel.setDynamicFont()
        messageLabel.attributedText = messageLabel.text?.with(characterSpacing: 1.0, lineSpacing: 2.0, alignment: .center, color: .feedbackTextLabelColor)
        acceptButton.titleLabel?.setDynamicFont()
        acceptButton.titleLabel?.attributedText = acceptButton.titleLabel?.text?.with(characterSpacing: 1.3, color: .unselectedTextButtonColor)
    }

    @IBAction func clickButton(_ sender: Any) {
        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
    }

}
