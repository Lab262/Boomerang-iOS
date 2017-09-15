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
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    
    
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
        Bundle.main.loadNibNamed("IconNavigationBar", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        titleLabel.setDynamicFont()
    }
    
    @IBInspectable var leftButtonIconImage: UIImage? {
        set {
            self.leftButtonIcon.image = newValue
        }
        get {
            return self.leftButtonIcon.image
        }
    }
    
    @IBInspectable var backgroundViewColor: UIColor? {
        set {
            self.view.backgroundColor = newValue
        }
        get {
            return self.view.backgroundColor
        }
    }
    
    
    @IBInspectable var rightBarIconImage: UIImage? {
        set {
            self.rightIcon.image = newValue
        }
        get {
            return self.rightIcon.image
        }
    }
    
    @IBInspectable var isHiddenRightBarIconImage: Bool {
        set {
            self.rightIcon.isHidden = newValue
        }
        get {
            return self.rightIcon.isHidden
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
    
    
    @IBInspectable var backgroundTitleColor: UIColor? {
        set {
            self.titleLabel.textColor = newValue
        }
        get {
            return self.titleLabel.textColor
        }
    }
    
}


