//
//  PhotoNavigationBar.swift
//  Boomerang
//
//  Created by Felipe perius on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoNavigationBar: UIView {
   
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var throwButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    func nibInit() {
        Bundle.main.loadNibNamed("PhotoNavigationBar", owner: self, options: nil)
        //self.addSubview(view)
        //view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        
    }

}
