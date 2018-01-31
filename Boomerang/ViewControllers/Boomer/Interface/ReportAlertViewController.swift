//
//  ReportAlertViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

class ReportAlertViewController: UIViewController {

    var titleText: String
    
    lazy var containerView: ReportAlertContainerView = {
        let containerView = ReportAlertContainerView(titleText: self.titleText)
        return containerView
    }()
    
    lazy var backgroundView: UIView = { [unowned self] in
        let backgroundView = UIView(frame: self.view.frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        return backgroundView
        }()
    
    private var currentReport: String?
    
    private var doneActionBlock: ((String?) -> ())?
    
    var containerShowConstraint: NSLayoutConstraint?
    var containerHideConstraint: NSLayoutConstraint?
    
    init(titleText: String) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showViewAnimation()
    }
    
    override func loadView() {
        super.loadView()
        configureView()
        setupViews()
        configureHideAndShowConstraints()
        setupConstraints()
    }
    
    private func setupConstraints() {
        configureContainer()
    }
    
    private func configureContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        changeContainerConstraint(isShowContainer: false)
    }
    
    func changeContainerConstraint(isShowContainer: Bool) {
        containerShowConstraint?.isActive = false
        containerHideConstraint?.isActive = false
        
        if isShowContainer {
            containerShowConstraint?.isActive = true
        } else {
            containerHideConstraint?.isActive = true
        }
    }
    
    private func configureHideAndShowConstraints() {
        containerHideConstraint = containerView.bottomAnchor.constraint(equalTo: view.topAnchor)
        containerShowConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 74.0)
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
    }
    
    private func configureView() {
        view.backgroundColor = .clear
    }
    
    func addButton(titleButton: String, border: Border, selectedBorder: Border) {
        let button = ReportAlertButtonContainerView(titleLabelText: titleButton, unselectedBorderButton: border, selectedBorderRadioButton: selectedBorder)
        containerView.addButtonInStackView(button: button)
        button.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        setupButtonContainerGestureRecognizer(buttonContainer: button)
    }
    
    func doneAction(completionHandler: @escaping (_ currentReport: String?) -> ()) {
        doneActionBlock = completionHandler
        containerView.doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
    }
    
    @objc func done(_ sender: UIButton) {
        doneActionBlock?(currentReport)
    }
    
    private func setupButtonContainerGestureRecognizer(buttonContainer: ReportAlertButtonContainerView) {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetViewDidTapped))
        gesture.numberOfTapsRequired = 1
        buttonContainer.isUserInteractionEnabled = true
        buttonContainer.addGestureRecognizer(gesture)
    }
    
    @objc func targetViewDidTapped(_ sender: UITapGestureRecognizer) {
        for container in containerView.radioButtonsContainer {
            container.radioButton.selectedButton = false
        }
        
        for container in containerView.radioButtonsContainer where container == sender.view {
            container.radioButton.selectedButton = true
            currentReport = container.titleLabel.text
        }
    }
}

// MARK: - PopUp Animation

extension ReportAlertViewController {
    
    func showViewAnimation() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.8
        }, completion: { (_) in
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.changeContainerConstraint(isShowContainer: true)
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    func dismissViewAnimation(completion: @escaping () -> Void) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.changeContainerConstraint(isShowContainer: false)
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            completion()
        })
    }
}
