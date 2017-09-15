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
    @IBOutlet weak var thingNameLabel: UILabel!
    @IBOutlet weak var containerIconImage: UIImageView!
    
    
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
        view.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: UIScreen.main.bounds.width, height: self.bounds.height*UIView.heightScaleProportion()))
        thingNameLabel.setDynamicFont()
    }
    
    override func awakeFromNib() {
        
    }
    
    func getHeightLabel() -> CGFloat {
        self.thingNameLabel.sizeToFit()
        let heightLine = lroundf(Float(self.thingNameLabel.font.lineHeight))
        let numberOfLines = lroundf(Float(self.thingNameLabel.frame.height/CGFloat(heightLine)))
        return CGFloat((numberOfLines-1)*heightLine)
    }
    
    @IBInspectable var thingNameLabelHidden: Bool {
        get {
            return thingNameLabel.isHidden
        }
        set {
            thingNameLabel.isHidden = newValue
            
        }
    }
    
   
}
