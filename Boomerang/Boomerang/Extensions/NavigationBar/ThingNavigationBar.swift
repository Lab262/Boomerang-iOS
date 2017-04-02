//
//  ThingNavigationBar.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 21/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThingNavigationBar: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var titleTransactionLabel: UILabel!
    @IBOutlet weak var thingNameLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    func nibInit() {
        Bundle.main.loadNibNamed("ThingNavigationBar", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        
    }
    
    @IBInspectable var titleTransactionLabelHidden: Bool {
        get {
            return titleTransactionLabel.isHidden
        }
        set {
            if newValue == true {
                titleTransactionLabel.isHidden = true
            } else {
                titleTransactionLabel.isHidden = false
            }
            
        }
    }
    
    @IBInspectable var thingNameLabelHidden: Bool {
        get {
            return thingNameLabel.isHidden
        }
        set {
            if newValue == true {
                thingNameLabel.isHidden = true
            } else {
                thingNameLabel.isHidden = false
            }
            
        }
    }
    
    @IBInspectable var typeImageHidden: Bool {
        get {
            return typeImage.isHidden
        }
        set {
            if newValue == true {
                typeImage.isHidden = true
            } else {
                typeImage.isHidden = false
            }
            
        }
    }
   
}
