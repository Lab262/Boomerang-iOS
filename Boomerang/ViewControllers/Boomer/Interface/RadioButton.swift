//
//  RadioButton.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    
    var border: Border {
        didSet {
            setNeedsLayout()
        }
    }
    
    var selectedBorder: Border {
        didSet {
            setNeedsLayout()
        }
    }
    
    var selectedButton: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    init(border: Border, selectedBorder: Border) {
        self.border = border
        self.selectedBorder = selectedBorder
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadiusBorder()
    }
    
    private func setupCornerRadiusBorder() {
        let currentBorder: Border
        
        if selectedButton {
            backgroundColor = selectedBorder.color
            currentBorder = selectedBorder
        } else {
            backgroundColor = .white
            currentBorder = border
        }
        
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = currentBorder.width
        layer.borderColor = currentBorder.color.cgColor
    }
}

class CornerRadiusButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 7
    }
}

