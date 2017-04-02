//
//  InterestedTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class InterestedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var interestedImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    static var identifier: String {
        return "interestedCell"
    }
    
    static var cellHeight: CGFloat {
        return 108.0
    }
    
    var presenter = InterestedPresenter()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadViewCell(){
        self.nameLabel.text = presenter.getInterested().user!.fullName!
        //self.messageLabel.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
