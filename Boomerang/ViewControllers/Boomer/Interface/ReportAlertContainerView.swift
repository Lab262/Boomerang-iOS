//
//  ReportAlertContainerView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

class ReportAlertContainerView: UIView {

    lazy var titleTextLabel: UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.font = .montserratSemiBold(size: 14)
        titleTextLabel.textAlignment = .left
        titleTextLabel.numberOfLines = 0
        return titleTextLabel
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var doneButton: CornerRadiusButton = {
        let doneButton = CornerRadiusButton()
        doneButton.backgroundColor = .reportAlertBorderButtonColor
        doneButton.setTitle("Pronto", for: .normal)
        doneButton.titleLabel?.font = .montserratBold(size: 14)
        doneButton.setTitleColor(.white, for: .normal)
        return doneButton
    }()
    
    var radioButtonsContainer = [ReportAlertButtonContainerView]()
    
    convenience init(titleText: String) {
        self.init()
        self.titleTextLabel.text = titleText
        configureView()
        setupViews()
        configureLabelsStack()
        configureButtonsStack()
        configureDoneButton()
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
    
    private func configureLabelsStack() {
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        labelsStackView.addArrangedSubview(titleTextLabel)
    }
    
    private func configureButtonsStack() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 20).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func configureDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 60).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 104).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -103).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupViews() {
        addSubview(labelsStackView)
        addSubview(buttonsStackView)
        addSubview(doneButton)
    }
    
    func addButtonInStackView(button: ReportAlertButtonContainerView) {
        radioButtonsContainer.append(button)
        buttonsStackView.addArrangedSubview(button)
    }
}

