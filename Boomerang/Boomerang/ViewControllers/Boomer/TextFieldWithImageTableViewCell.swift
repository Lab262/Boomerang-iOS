//
//  TextFieldWithImageTableViewCell.swift
//  BilinEntregador
//
//  Created by Huallyd Smadi on 12/01/17.
//  Copyright © 2017 br.com.mobigag. All rights reserved.
//

import UIKit

class TextFieldWithImageTableViewCell: UITableViewCell {
  
    @IBOutlet weak var anexPhotoButton: UIButtonWithPicker!
    
    var fieldCellData: FieldCellData? {
        didSet {
            self.updateCell()
        }
    }

    var annexImage: UIImage? {
        didSet{
            self.updateImage()
        }
    }
    
    @IBOutlet weak var titleFieldLabel: UILabel!
    
    @IBOutlet weak var tex: UIButton!
    
    //@IBOutlet weak var photoImage: UIImageView!
    
    static let identifier = "textFieldWithImageCell"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // self.photoImage.layer.cornerRadius = self.photoImage.frame.width/2
      //  self.photoImage.layer.masksToBounds = true
        //self.photoImage.layer.borderWidth = 1
       // self.photoImage.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func updateImage(){
    
        if let image = self.annexImage {
                     
            //self.photoImage.isHidden = false
            //self.photoImage.image = image
        } else {
           // self.photoImage.isHidden = true
        }
    }
    
    func updateCell() {
        
        self.titleFieldLabel.text = self.fieldCellData?.titleField
        
      
        
    }

    
}
