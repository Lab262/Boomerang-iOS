//
//  AmountPostInteractionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class AmountPostInteractionTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "amountPostCell"
    }
    
    static var cellHeight: CGFloat {
        return 44.0
    }
    
    static var nibName: String {
        return "AmountPostInteractionTableViewCell"
    }

    @IBOutlet weak var likeAmountButton: UIButton!
    
    @IBOutlet weak var commentAmountButton: UIButton!
    
    @IBOutlet weak var recommendationAmountButton: UIButton!
    
    var presenter = AmountPostInteractionPresenter()
    
    var likeAmount: String? {
        didSet {
            likeAmountButton.setTitle("\(likeAmount!) curtir", for: .normal)
        }
    }
    
    var commentAmount: String? {
        didSet {
            commentAmountButton.setTitle("\(commentAmount!) comentários", for: .normal)
        }
    }
    var recommendedAmount: String? {
        didSet {
            recommendationAmountButton.setTitle("\(recommendedAmount!) recomendações", for: .normal)
        }
    }
    
    var isLikedPost: Bool? {
        didSet {
            likeAmountButton.isSelected = isLikedPost!
            likeAmountButton.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        presenter.setViewDelegate(delegate: self)
        configureLikeButtonState()
    }
    
    func configureLikeButtonState() {
        likeAmountButton.setTitleColor(UIColor.colorWithHexString("ACB8C1"), for: .normal)
        
        likeAmountButton.titleLabel?.attributedText = likeAmountButton.titleLabel?.text?.with(characterSpacing: 2, lineSpacing: 12, alignment: .center, color: (likeAmountButton.titleLabel!.textColor)!)
        
        likeAmountButton.setTitleColor(UIColor.colorWithHexString("F6A01F"), for: .selected)
        likeAmountButton.setImage(#imageLiteral(resourceName: "like-count-icon"), for: .normal)
        likeAmountButton.setImage(#imageLiteral(resourceName: "like_selected_count_icon"), for: .selected)
    }
    
    @IBAction func likedPost(_ sender: Any) {
        likeAmountButton.isSelected ? presenter.unlikePost() : presenter.likedPost()
        likeAmountButton.isUserInteractionEnabled = false
    }
}

extension AmountPostInteractionTableViewCell: AmountPostDelegate {
    
    func showMessage(isSuccess: Bool, msg: String) {
        
    }
}
