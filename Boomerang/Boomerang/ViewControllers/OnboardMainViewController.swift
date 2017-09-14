//
//  OnboardMainViewController.swift
//  Boomerang
//
//  Created by Luís Resende on 14/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class OnboardMainViewController: UIViewController {
    
    @IBOutlet weak var onboardCollectionView: UICollectionView!
    @IBOutlet weak var viewPages: UIView!
    @IBOutlet weak var skipButton: UIButton!

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var pageIndicatorView: PageIndicatorView?
    var presenter = OnboardMainPresenter()
    var currentIndex = 0
    
    let titleForward = "PRÓXIMO"
    let titleStart = "COMEÇAR"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDelegate()
        setDynamicFonts()
        registerNib()
        initializePageIndicatorView()
        setOnboarData()
        isToHideBackButton(isToHide: true)
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(delegate: self)
    }
    
    func setDynamicFonts(){
        
        skipButton.titleLabel?.attributedText = skipButton.titleLabel?.text?.with(characterSpacing: 3.0, alignment: .center, color: UIColor.purpleTextColor)
        
        backButton.titleLabel?.setDynamicFont()
        forwardButton.titleLabel?.setDynamicFont()
        skipButton.titleLabel?.setDynamicFont()
    }
    
    func registerNib(){
        onboardCollectionView.registerNibFrom(OnboardCollectionViewCell.self)
    }
    
    func initializePageIndicatorView(){
        pageIndicatorView = PageIndicatorView(frame: viewPages.frame)
        pageIndicatorView?.delegate = self
        viewPages.addSubview(pageIndicatorView!)
        pageIndicatorView?.centerXAnchor.constraint(equalTo: viewPages.centerXAnchor).isActive = true
        pageIndicatorView?.centerYAnchor.constraint(equalTo: viewPages.centerYAnchor).isActive = true
        pageIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setOnboarData(){
        presenter.setOnboardData()
    }
    
    
    func generateOnboardCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCollectionViewCell.identifier, for: indexPath) as! OnboardCollectionViewCell
        
        cell.onboardData = presenter.onboardData[indexPath.row]
        
        return cell
    }
    
    func setupButtonsBasedOnCurrentPage() {
        if pageIndicatorView?.selectedPage != currentIndex {
            currentIndex = (pageIndicatorView?.selectedPage)!
            
            //First page
            if currentIndex == 0 {
                isToHideBackButton(isToHide: true)
                isToHideSkipButton(isToHide: false)
                isToChangeForwardButton(isToChange: false)
            }//Last page
            else if currentIndex == (presenter.onboardData.count-1){
                isToHideBackButton(isToHide: false)
                isToHideSkipButton(isToHide: true)
                isToChangeForwardButton(isToChange: true)
            }//Other pages
            else {
                isToHideBackButton(isToHide: false)
                isToHideSkipButton(isToHide: false)
                isToChangeForwardButton(isToChange: false)
            }
        }
    }
    
    private func isToHideBackButton(isToHide:Bool){
        leftImage.isHidden = isToHide
        backButton.isHidden = isToHide
        backButton.isEnabled = !isToHide
    }
    
    private func isToHideSkipButton(isToHide:Bool){
        skipButton.isHidden = isToHide
        skipButton.isEnabled = !isToHide
    }
    
    private func isToChangeForwardButton(isToChange:Bool){
        if isToChange {
            forwardButton.setTitle(titleStart, for: .normal)
            rightImage.image = #imageLiteral(resourceName: "checkWhite")
        }else {
            forwardButton.setTitle(titleForward, for: .normal)
            rightImage.image = #imageLiteral(resourceName: "arrowWhiteRight")
        }
    }
    
    @IBAction func clickedForwardButton(_ sender: Any) {
    }
    
    @IBAction func clickedBackButton(_ sender: Any) {
    }
    
    @IBAction func clickedSkipButton(_ sender: Any) {
    }
}

extension OnboardMainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageIndicatorView?.reload()
        return presenter.onboardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.generateOnboardCell(collectionView, cellForItemAt: indexPath)
        
        return cell
    }
}

extension OnboardMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let flowLayout = (onboardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let indexPath = self.onboardCollectionView.indexPathForItem(at: self.onboardCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: onboardCollectionView.frame.width/2, y: 0))
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
            setupButtonsBasedOnCurrentPage()
        }
    }
}

extension OnboardMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return OnboardCollectionViewCell.cellSize
    }
}

extension OnboardMainViewController: PageIndicatorViewDelegate {
    
    var numberOfPages: Int {
        return presenter.onboardData.count
    }
    
    var indicatorHeight: CGFloat {
        return 6.0
    }
    
    var defaultWidth: CGFloat {
        return 7.0
    }
    
    var selectedWidth: CGFloat {
        return 20.0
    }
    
    var defaultAlpha: CGFloat {
        return 0.3
    }
    
    var selectedAlpha: CGFloat {
        return 1.0
    }
    
    var animationDuration: Double {
        return 0.2
    }
    
    var indicatorsColor: UIColor {
        return UIColor.purpleTextColor
    }
    
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {
        
        return (.horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5.0)
    }
}

extension OnboardMainViewController: OnboardMainDelegate {
    
    func reload() {
        self.onboardCollectionView.reloadData()
        pageIndicatorView?.reload()
    }
}

