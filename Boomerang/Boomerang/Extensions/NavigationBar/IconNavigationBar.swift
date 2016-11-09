//
//  IconNavigationBar.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


class IconNavigationBar: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var leftButtonIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    
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
        Bundle.main.loadNibNamed("IconNavigationBar", owner: self, options: nil)?[0]
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    @IBInspectable var leftButtonIconImage: UIImage? {
        set {
            self.leftButtonIcon.image = newValue
        }
        get {
            return self.leftButtonIcon.image
        }
    }
    
    @IBInspectable var titleIconImage: UIImage? {
        set {
            self.titleIcon.image = newValue
        }
        get {
            return self.titleIcon.image
        }
    }
    
    @IBInspectable var titleLabelText: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
}


