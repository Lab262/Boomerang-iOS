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
    
    
    @IBOutlet weak var navigationView: IconNavigationBar!
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
   
}
