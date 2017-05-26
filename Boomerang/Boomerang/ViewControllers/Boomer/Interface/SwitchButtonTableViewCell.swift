//
//  SwitchButtonTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 30/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SwitchButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borrowedImageView: UIImageView!
    @IBOutlet weak var borrowedButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var swapImageView: UIImageView!
    
    var handlerOptionSelected: ((Bool) -> ())?
    var isFirstOptionSelected = true
    
    static var identifier: String {
        return "SwitchButtonCell"
    }
    
    static var nibName: String {
        return "SwitchButtonTableViewCell"
    }
    
    var firstOptionTitle: String? {
        didSet{
            var title:NSAttributedString = NSAttributedString()
            if isFirstOptionSelected {
                title = (firstOptionTitle?.with(characterSpacing: 1.3, color:UIColor.white))!
            }else{
                title = (firstOptionTitle?.with(characterSpacing: 1.3, color:UIColor.unselectedTextButtonColor))!
            }
            borrowedButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    var secondOptionTitle: String? {
        didSet{
            var title:NSAttributedString = NSAttributedString()
            if isFirstOptionSelected {
                title = (secondOptionTitle?.with(characterSpacing: 1.3, color:UIColor.unselectedTextButtonColor))!
            }else{
                title = (secondOptionTitle?.with(characterSpacing: 1.3, color:UIColor.white))!
            }
            swapButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borrowedButton.titleEdgeInsets.left = 20;
        swapButton.titleEdgeInsets.left = 20;
        borrowedButton.titleLabel?.setDynamicFont()
        swapButton.titleLabel?.setDynamicFont()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        updateStateButtons(button: sender)
    }
    
    func updateStateButtons(button: UIButton){
        if button == self.borrowedButton{
            selectButton(button: self.borrowedButton, title: firstOptionTitle!, imageView: self.borrowedImageView)
            unselectButton(button: self.swapButton, title: secondOptionTitle!, imageView: self.swapImageView)
            self.handlerOptionSelected?(true)
        }else{
            selectButton(button: self.swapButton, title: secondOptionTitle!, imageView: self.swapImageView)
                unselectButton(button: self.borrowedButton, title: firstOptionTitle!, imageView: self.borrowedImageView)
            self.handlerOptionSelected?(false)
        }
    }
    
    func selectButton(button: UIButton, title: String, imageView: UIImageView){
        updatePropertysButtons(button: button, title: title, colorButton: .unselectedTextButtonColor, colorText: UIColor.white, image: #imageLiteral(resourceName: "ic_swipe_check"), imageView: imageView)
    }
    
    func unselectButton(button: UIButton, title: String, imageView: UIImageView){
        updatePropertysButtons(button: button, title: title, colorButton: UIColor.white, colorText: .unselectedTextButtonColor, image: #imageLiteral(resourceName: "ic_swipeOval"), imageView: imageView)
    }
    
    func updatePropertysButtons(button: UIButton, title:String, colorButton:UIColor, colorText: UIColor, image:UIImage, imageView: UIImageView){
        imageView.image = image
        button.backgroundColor = colorButton
        let titleCustom = title.with(characterSpacing: 1.3,color:colorText)
        button.setAttributedTitle(titleCustom, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
