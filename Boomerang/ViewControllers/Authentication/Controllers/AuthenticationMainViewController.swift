
//
//  AuthenticationMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4


class AuthenticationMainViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var onboardCollectionView: UICollectionView!
    @IBOutlet weak var viewPages: UIView!
    
    var pageIndicatorView: PageIndicatorView?
    var presenter = AuthenticationPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupCustomLabel()
        setupViewDelegate()
        registerNib()
        initializePageIndicatorView()
        setOnboarData()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(delegate: self)
    }
    
    func registerNib(){
        onboardCollectionView.registerNibFrom(OnboardAuthenticationCollectionViewCell.self)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardAuthenticationCollectionViewCell.identifier, for: indexPath) as! OnboardAuthenticationCollectionViewCell
        
        cell.onboardData = presenter.onboardData[indexPath.row]
        
        return cell
    }
    
    @IBAction func facebookAction(_ sender: Any) {
       
//        PromoCodeController.presentMe(inParent: self, delegate: self)

        self.presenter.loginFacebook()

    }
    
    func showHomeVC() {
        
        self.presenter.requestInformationsProfileUser { (success, msg) in
            if success {
                self.finishLoadingView()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vcToShow = storyboard.instantiateInitialViewController()!
                self.present(vcToShow, animated: true, completion: nil)
            }else {
                //TODO: Review text when have error in login
                self.showAlertError(message: msg)
            }
        }
        //        UserRequest.getProfileUser(completionHandler: { (success, msg) in
        //            if success {
        //                self.requestAllPostTypes(completionHandler: { (success, msg) in
        //                    if success {
        //                        self.requestAllPostConditions(completionHandler: { (success, msg) in
        //                            if success {
        //                                self.requestSchemeStatus(completionHandler: { (success, msg) in
        //                                    if success {
        //                                        self.view.unload()
        //                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //                                        let vcToShow = storyboard.instantiateInitialViewController()!
        //                                        self.present(vcToShow, animated: true, completion: nil)
        //                                    }
        //                                })
        //                            }
        //                        })
        //                    }
        //                })
        //            }
        //        })
    }
    
    func showAlertError(message: String){
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: "Erro: \(message)! Tente novamente mais tarde", negativeAction: "Ok") { (isPositive) in
        }
    }
    
    func verifyIfFirstTimeLogin() -> Bool {
        //TODO: Verify rules of onboardview
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.string(forKey: OnboardKeyLogin.keyLoginFirstTime) {
            return false
        }else{
            userDefaults.set(OnboardKeyLogin.keyLoginFirstTime, forKey: OnboardKeyLogin.keyLoginFirstTime)
            return true
        }
    }
    
    func showOnboarMainViewController(){
        let onboardMaindViewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Authentication", identifier: "OnboardMainViewController")
        self.present(onboardMaindViewController!, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func requestAllPostTypes(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllTypes { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestAllPostConditions(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllConditions { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
}

extension AuthenticationMainViewController: PromoCodeRequestDelegate {
    func afterValidateCode() {
        self.presenter.loginFacebook()
    }
}

extension AuthenticationMainViewController: UICollectionViewDataSource {
    
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

extension AuthenticationMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let flowLayout = (onboardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let indexPath = self.onboardCollectionView.indexPathForItem(at: self.onboardCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: onboardCollectionView.frame.width/2, y: 0))
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
        }
    }
}

extension AuthenticationMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return OnboardAuthenticationCollectionViewCell.cellSize
    }
}

extension AuthenticationMainViewController: PageIndicatorViewDelegate {
    
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
        return 0.5
    }
    
    var selectedAlpha: CGFloat {
        return 1.0
    }
    
    var animationDuration: Double {
        return 0.2
    }
    
    var indicatorsColor: UIColor {
        return UIColor.white
    }
    
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {
        
        return (.horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5.0)
    }
}

extension AuthenticationMainViewController: AuthenticationDelegate {
    func showHome() {
        if self.verifyIfFirstTimeLogin() {
            self.showOnboarMainViewController()
        }else {
            self.showHomeVC()
        }
    }
    
    func showMsg(success: Bool, msg: String) {
        
    }
    
    func startLoadingView() {
        self.view.loadAnimation()
    }
    
    func finishLoadingView() {
        self.view.unload()
    }
    
    func reload() {
        self.onboardCollectionView.reloadData()
        pageIndicatorView?.reload()
    }
}


