//
//  EmptyView.swift
//  Boomerang
//
//  Created by Luís Resende on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageEmpty: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var constraintButton: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    func nibInit() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        configureDynamicLabels()
    }
    
    func configureDynamicLabels(){
        self.titleLabel.setDynamicFont()
        self.descriptionLabel.setDynamicFont()
        self.emptyButton.titleLabel?.setDynamicFont()
    }
    
    @IBInspectable var emptyImage: UIImage? {
        set {
            self.imageEmpty.image = newValue
        }
        get {
            return self.imageEmpty.image
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
    
    @IBInspectable var descriptionLabelText: String? {
        set {
            self.descriptionLabel.text = newValue
        }
        get {
            return self.descriptionLabel.text
        }
    }
    
    @IBInspectable var emptyButtonText: String? {
        set {
            self.emptyButton.setTitle(newValue, for: .normal)
        }
        get {
            return self.emptyButton.titleLabel?.text
        }
    }
    
    @IBInspectable var constraintButtonMultiplier: CGFloat? {
        set {
            self.constraintButton.constant = newValue!
        }
        get {
            return self.constraintButton.constant
        }
    }
}
