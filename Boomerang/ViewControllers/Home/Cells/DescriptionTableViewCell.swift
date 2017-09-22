//
//  DescriptionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    static var identifier: String {
        return "descriptionCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "DescriptionTableViewCell"
    }
    
    @IBOutlet weak var descriptionPostLabel: UILabel!
    @IBOutlet weak var titlePostLabel: UILabel!
    
    var presenter = DetailThingPresenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionPostLabel.setDynamicFont()
        titlePostLabel.setDynamicFont()
    }
    
    func updateCell(){
        descriptionPostLabel.text = presenter.post.content
        titlePostLabel.text = presenter.post.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
