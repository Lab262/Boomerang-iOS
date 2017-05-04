//
//  ThingBar.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 04/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThingBar: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleBarLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func leftAction(_ sender: Any) {
        if let navController = UIApplication.topViewController()?.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    func nibInit() {
        Bundle.main.loadNibNamed("ThingBar", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    @IBInspectable var titleLabelText: String? {
        set {
            self.titleBarLabel.text = newValue
        }
        get {
            return self.titleBarLabel.text
        }
    }

}
