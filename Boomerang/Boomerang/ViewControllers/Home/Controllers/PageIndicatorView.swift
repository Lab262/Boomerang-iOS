//
//  PageIndicatorView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 07/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//


import UIKit

protocol PageIndicatorViewDelegate {
    
    var numberOfPages: Int {get}
    var indicatorHeight: CGFloat {get}
    var defaultWidth: CGFloat {get}
    var selectedWidth: CGFloat {get}
    var defaultAlpha: CGFloat {get}
    var selectedAlpha: CGFloat {get}
    var animationDuration: Double {get}
    var indicatorsColor: UIColor {get}
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {get}
}

extension PageIndicatorViewDelegate {
    
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {
        
        return (UILayoutConstraintAxis.horizontal, alignment: UIStackViewAlignment.center, distribution: UIStackViewDistribution.equalSpacing, spacing: 5.0)
    }
}

class PageIndicatorView: UIView {
    
    var selectedPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }
    
    var delegate: PageIndicatorViewDelegate? {
        didSet {
            reload()
        }
    }
    
    private(set) var stackView: UIStackView!
    private(set) var pageIndicators: [UIView] = []
    private(set) var widthConstraints: [NSLayoutConstraint] = []
    private(set) var heightConstraints: [NSLayoutConstraint] = []
    private var growAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .linear, animations: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateStackView()
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload() {
        tearDown()
        setUp()
    }
    
    private func generateStackView() {
        stackView = UIStackView(frame: CGRect.zero)
        
        if let delegate = delegate {
            updateStackView(delegate)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func tearDown() {
        
        pageIndicators.forEach { stackView.removeArrangedSubview($0) }
        NSLayoutConstraint.deactivate(widthConstraints + heightConstraints)
        pageIndicators.removeAll()
        widthConstraints.removeAll()
        heightConstraints.removeAll()
    }
    
    private func setUp() {
        guard let delegate = delegate else {
            return
        }
        
        updateStackView(delegate)
        generateIndicators(delegate)
        generateAnimator(delegate)
    }
    
    private func generateIndicators(_ delegate: PageIndicatorViewDelegate) {
        
        pageIndicators = (0..<delegate.numberOfPages).map { _ in
            let view = UIView()
            view.backgroundColor = delegate.indicatorsColor
            view.layer.cornerRadius = delegate.indicatorHeight/2
            
            return view
        }
        
        widthConstraints = pageIndicators.map { $0.widthAnchor.constraint(equalToConstant: delegate.defaultWidth) }
        heightConstraints = pageIndicators.map { $0.heightAnchor.constraint(equalToConstant: delegate.indicatorHeight) }
        
        NSLayoutConstraint.activate(widthConstraints + heightConstraints)
        
        pageIndicators.forEach { self.stackView.addArrangedSubview($0) }
        stackView.sizeToFit()
        
        updateIndicators()
    }
    
    private func generateAnimator(_ delegate: PageIndicatorViewDelegate) {
        growAnimator = UIViewPropertyAnimator(duration: delegate.animationDuration, curve: .linear, animations: nil)
    }
    
    private func updateStackView(_ delegate: PageIndicatorViewDelegate) {
        stackView.axis = delegate.stackViewConfig.axis
        stackView.alignment = delegate.stackViewConfig.alignment
        stackView.distribution = delegate.stackViewConfig.distribution
        stackView.spacing = delegate.stackViewConfig.spacing
    }
    
    private func updateIndicators() {
        updateIndicatorsWidth()
        
        growAnimator.addAnimations {
            self.stackView.layoutIfNeeded()
            self.updateIndicatorsAlpha()
        }
        
        growAnimator.startAnimation()
    }
    
    private func updateIndicatorsWidth() {
        
        for i in 0..<(delegate?.numberOfPages ?? 0) {
            
            let constraint = widthConstraints[i]
            if i == selectedPage {
                
                constraint.constant = delegate?.selectedWidth ?? 0
            } else {
                
                constraint.constant = delegate?.defaultWidth ?? 0
            }
        }
    }
    
    private func updateIndicatorsAlpha() {
        
        for i in 0..<(delegate?.numberOfPages ?? 0) {
            
            let indicator = pageIndicators[i]
            if i == selectedPage {
                
                indicator.alpha = delegate?.selectedAlpha ?? 0
            } else {
                
                indicator.alpha = delegate?.defaultAlpha ?? 0
            }
        }
    }
}
