//
//  EvaluationViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EvaluationViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var evaluationTextLabel: UILabel!
    @IBOutlet weak var evaluationCommentLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImage.image = ApplicationState.sharedInstance.currentUser?.profileImage
        configureStarButtons()
    }
    
    func configureStarButtons() {
        starButtons.forEach  {
            $0.setImage(#imageLiteral(resourceName: "star-deselect-button"), for: .normal)
            $0.setImage(#imageLiteral(resourceName: "star_selected_button"), for: .selected)
            $0.isSelected = false
        }
    }
    
    func disableAlphaOfComponents() {
        evaluationCommentLabel.alpha = 1.0
        doneButton.alpha = 1.0
        textView.alpha = 1.0
    }
    
    @IBAction func selectedStar(_ sender: UIButton) {
        for i in (0..<starButtons.count) where i > starButtons.index(of: sender)! && starButtons[i].isSelected {
            starButtons[i].isSelected = false
        }
        
        for i in (0..<starButtons.index(of: sender)!+1) where !starButtons[i].isSelected {
            starButtons[i].isSelected = true
        }
    }

    @IBAction func doneAction(_ sender: Any) {
        
    }

}
