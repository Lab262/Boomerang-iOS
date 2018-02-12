//
//  ReportAlertDoneView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 31/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

class ReportAlertDoneView: UIView {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var titleTextLabel: UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.font = .montserratSemiBold(size: 14)
        titleTextLabel.textAlignment = .center
        titleTextLabel.numberOfLines = 0
        return titleTextLabel
    }()
    
    lazy var descriptionTextLabel: UILabel = {
        let descriptionTextLabel = UILabel()
        descriptionTextLabel.font = .montserratLight(size: 14)
        descriptionTextLabel.textColor = .colorWithHexString("606060")
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.numberOfLines = 0
        return descriptionTextLabel
    }()
    
    lazy var doneButton: CornerRadiusButton = {
        let doneButton = CornerRadiusButton()
        doneButton.backgroundColor = .reportAlertBorderButtonColor
        doneButton.setTitle("Ok!", for: .normal)
        doneButton.titleLabel?.font = .montserratBold(size: 14)
        doneButton.setTitleColor(.white, for: .normal)
        return doneButton
    }()

    convenience init(logoImage: UIImage, titleText: String, descriptionText: String) {
        self.init()
        
        self.logoImageView.image = logoImage
        self.titleTextLabel.text = titleText
        self.descriptionTextLabel.text = descriptionText
        
        configureView()
        setupViews()
        setupAutoLayout()
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.cornerRadius = 8.0
        backgroundColor = .white
    }
    
    private func setupViews() {
        addSubview(logoImageView)
        addSubview(titleTextLabel)
        addSubview(descriptionTextLabel)
        addSubview(doneButton)
    }
    
    private func setupAutoLayout() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 36).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 53).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 77).isActive = true
        
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 22).isActive = true
        titleTextLabel.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor).isActive = true
        titleTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        descriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextLabel.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 8).isActive = true
        descriptionTextLabel.centerXAnchor.constraint(equalTo: titleTextLabel.centerXAnchor).isActive = true
        descriptionTextLabel.leadingAnchor.constraint(equalTo: titleTextLabel.leadingAnchor).isActive = true
        descriptionTextLabel.trailingAnchor.constraint(equalTo: titleTextLabel.trailingAnchor).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 50).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 104).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -103).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
}
