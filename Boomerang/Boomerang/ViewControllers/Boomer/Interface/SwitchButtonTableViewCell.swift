//
//  SwitchButtonTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 30/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SwitchButtonTableViewCell: UITableViewCell {
      static var cellIdentifier = "SwitchButtonCell"
    
    
    @IBOutlet weak var boorowedImageView: UIImageView!
    @IBOutlet weak var borrowedButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var swapImageView: UIImageView!
    
    var firstOptionTitle: String? {
        didSet{
            let title = firstOptionTitle?.with(characterSpacing: 1.3, color:UIColor.white)
            borrowedButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    var secondOptionTitle: String? {
        didSet{
            let title = secondOptionTitle?.with(characterSpacing: 1.3,color:.unselectedTextButtonColor)
            swapButton.setAttributedTitle(title, for: .normal)
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borrowedButton.titleEdgeInsets.left = 20;
        swapButton.titleEdgeInsets.left = 20;
        // Initialization code
    }
    @IBAction func borrowAction(_ sender: Any) {
        self.boorowedImageView.image = #imageLiteral(resourceName: "ic_swipe_check")
        self.borrowedButton.backgroundColor = .unselectedTextButtonColor
        
        let titleFirst = firstOptionTitle?.with(characterSpacing: 1.3, color:UIColor.white)
        borrowedButton.setAttributedTitle(titleFirst, for: .normal)
        
        self.swapImageView.image =  #imageLiteral(resourceName: "ic_swipeOval")
        self.swapButton.backgroundColor = UIColor.white
        
        let titleSecond = secondOptionTitle?.with(characterSpacing: 1.3,color:.unselectedTextButtonColor)
        swapButton.setAttributedTitle(titleSecond, for: .normal)
    }
    @IBAction func swapAction(_ sender: Any) {
        self.boorowedImageView.image = #imageLiteral(resourceName: "ic_swipeOval")
        self.borrowedButton.backgroundColor = UIColor.white
        let titleFirst = firstOptionTitle?.with(characterSpacing: 1.3,color:.unselectedTextButtonColor)
        borrowedButton.setAttributedTitle(titleFirst, for: .normal)
        
        self.swapImageView.image =  #imageLiteral(resourceName: "ic_swipe_check")
        self.swapButton.backgroundColor =  .unselectedTextButtonColor
        let titleSecond = secondOptionTitle?.with(characterSpacing: 1.3,color:UIColor.white)
        swapButton.setAttributedTitle(titleSecond, for: .normal)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
