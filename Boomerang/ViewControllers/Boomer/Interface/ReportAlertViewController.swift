//
//  ReportAlertViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/01/2018.
//  Copyright © 2018 Lab262. All rights reserved.
//

import UIKit

protocol ReportAlertDelegate {
    func dismiss()
}

class ReportAlertViewController: UIViewController {

    private var titleText: String?
    private var logoImage: UIImage?
    private var descriptionText: String?
    
    lazy var containerView: ReportAlertContainerView = {
        let containerView = ReportAlertContainerView(titleText: self.titleText ?? "")
        return containerView
    }()
    
    lazy var containerDoneView: ReportAlertDoneView = {
        let containerDoneView = ReportAlertDoneView(logoImage: self.logoImage ?? UIImage(), titleText: self.titleText ?? "", descriptionText: self.descriptionText ?? "")
        return containerDoneView
    }()
    
    lazy var backgroundView: UIView = { [unowned self] in
        let backgroundView = UIView(frame: self.view.frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        return backgroundView
    }()
    
    lazy var dismissButton: UIButton = { [unowned self] in
        let button = UIButton(frame: self.view.frame)
        button.backgroundColor = .clear
        return button
    }()
    
    private var currentReport: String?
    
    private var doneActionBlock: ((String?) -> ())?
    
    var delegate: ReportAlertDelegate?
    
    var containerShowConstraint: NSLayoutConstraint?
    var containerHideConstraint: NSLayoutConstraint?
    
    init(titleText: String, delegate: ReportAlertDelegate) {
        self.titleText = titleText
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    init(titleText: String, descriptionText: String, logoImage: UIImage, delegate: ReportAlertDelegate) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.logoImage = logoImage
        self.delegate = delegate
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
        
        if let _ = titleText, let _ = descriptionText, let _ = logoImage {
            containerDoneView.translatesAutoresizingMaskIntoConstraints = false
            containerDoneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            containerDoneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            changeContainerConstraint(isShowContainer: false)
        } else {
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            changeContainerConstraint(isShowContainer: false)
        }
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
        if let _ = titleText, let _ = descriptionText, let _ = logoImage {
            containerHideConstraint = containerDoneView.bottomAnchor.constraint(equalTo: view.topAnchor)
            containerShowConstraint = containerDoneView.topAnchor.constraint(equalTo: view.topAnchor, constant: 74.0)
        } else {
            containerHideConstraint = containerView.bottomAnchor.constraint(equalTo: view.topAnchor)
            containerShowConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 74.0)
        }
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(dismissButton)
        
        if let _ = titleText, let _ = descriptionText, let _ = logoImage {
            view.addSubview(containerDoneView)
        } else {
            view.addSubview(containerView)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        
        dismissButton.addTarget(self, action: #selector(dismissViewAnimation(_:)), for: .touchUpInside)
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
        
        if let _ = titleText, let _ = descriptionText, let _ = logoImage {
            containerDoneView.doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        } else {
            containerView.doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        }
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
    
    func startLoading() {
        self.view.loadAnimation()
    }
    
    func finishLoading() {
        self.view.unload()
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
    
    func dismissViewAnimation(_ sender: UIButton? = nil) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.changeContainerConstraint(isShowContainer: false)
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.dismiss(animated: false, completion: nil)
            self.delegate?.dismiss()
        })
    }
}
