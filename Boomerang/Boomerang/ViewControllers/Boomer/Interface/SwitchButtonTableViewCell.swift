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
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func borrowAction(_ sender: Any) {
        self.boorowedImageView.image = #imageLiteral(resourceName: "ic_swipe_check")
        self.borrowedButton.backgroundColor = UIColor.colorWithHexString("903A7B")
        self.borrowedButton.setTitleColor(UIColor.white, for: .normal)
        
        self.swapImageView.image =  #imageLiteral(resourceName: "ic_swipeOval")
        self.swapButton.backgroundColor = UIColor.white
        self.swapButton.setTitleColor(UIColor.colorWithHexString("903A7B"), for: .normal)
    }
    @IBAction func swapAction(_ sender: Any) {
        self.boorowedImageView.image = #imageLiteral(resourceName: "ic_swipeOval")
        self.borrowedButton.backgroundColor = UIColor.white
        self.borrowedButton.setTitleColor(UIColor.colorWithHexString("903A7B"), for: .normal)
        
        self.swapImageView.image =  #imageLiteral(resourceName: "ic_swipe_check")
        self.swapButton.backgroundColor =  UIColor.colorWithHexString("903A7B")
        self.swapButton.setTitleColor(UIColor.white, for: .normal)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
