//
//  ReportAlertButtonContainerView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

struct Border {
    let width: CGFloat
    let color: UIColor
        
    init?(width: CGFloat, color: UIColor) {
        if width <= 0 {
            return nil
        }
        self.width = width
        self.color = color
    }
}

class ReportAlertButtonContainerView: UIView {
    
    let unselectedBorderButton: Border
        
    let selectedBorderButton: Border
        
    lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.font = .montserratLight(size: 15)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = false
            
        return titleLabel
    }()
        
    lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(border: self.unselectedBorderButton, selectedBorder: self.selectedBorderButton)
        radioButton.isUserInteractionEnabled = false
        return radioButton
    }()
        
    init(titleLabelText: String, unselectedBorderButton: Border, selectedBorderRadioButton: Border) {
        self.unselectedBorderButton = unselectedBorderButton
        self.selectedBorderButton = selectedBorderRadioButton
        super.init(frame: .zero)
        self.titleLabel.text = titleLabelText
        setupViews()
        setupAutoLayout()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func changeStateRadioButton() {
        radioButton.selectedButton = !radioButton.selectedButton
    }
        
    func setupViews() {
        addSubview(titleLabel)
        addSubview(radioButton)
    }
        
    func setupAutoLayout() {
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        radioButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: 14).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: -15).isActive = true
    }
}
