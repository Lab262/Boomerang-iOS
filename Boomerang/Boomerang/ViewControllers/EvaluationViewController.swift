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
        }
    }
    
    @IBAction func selectedStar(_ sender: UIButton) {
        for i in (0..<starButtons.count) {
            starButtons[i].isSelected = false
        }
        
        for i in (0..<starButtons.index(of: sender)!+1) {
            starButtons[i].alphaAnimation()
            starButtons[i].isSelected = true
        }
    }

    @IBAction func doneAction(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
}
