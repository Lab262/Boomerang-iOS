
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
    
    var presenter = AuthenticationPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupCustomLabel()
        setupViewDelegate()
        registerNib()
        setOnboarData()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(delegate: self)
    }
    
    func registerNib(){
        onboardCollectionView.registerNibFrom(OnboardAuthenticationCollectionViewCell.self)
    }
    
    func setOnboarData(){
        presenter.setOnboardData()
    }
    
    func generateOnboardCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardAuthenticationCollectionViewCell.identifier, for: indexPath) as! OnboardAuthenticationCollectionViewCell
        
        cell.onboardData = presenter.onboardData[indexPath.row]
        
        return cell
    }
    
//    func setupCustomLabel(){
//        let textWelcomeLabel = NSMutableAttributedString(string: defaultTextTitleWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratBlack(size: defaultSizeFontWelcomeLabel)])
//        
//        let textWelcomeDescriptionLabel = NSMutableAttributedString(string: defaultTextDescriptionWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratLight(size: defaultSizeFontWelcomeLabel)])
//        
//        textWelcomeLabel.append(textWelcomeDescriptionLabel)
//        self.welcomeLabel.attributedText = textWelcomeLabel
//    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
//        PromoCodeController.presentMe(inParent: self) { (item) in
//
//        }
       self.presenter.loginFacebook()
    }

    func showHomeVC() {
        
        self.requestAllPostTypes(completionHandler: { (success, msg) in
            if success {
                self.requestAllPostConditions(completionHandler: { (success, msg) in
                    if success {
                        self.requestSchemeStatus(completionHandler: { (success, msg) in
                            if success {
                                self.finishLoadingView()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vcToShow = storyboard.instantiateInitialViewController()!
                                self.present(vcToShow, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        })
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

extension AuthenticationMainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.onboardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.generateOnboardCell(collectionView, cellForItemAt: indexPath)
        
        return cell
    }
}

extension AuthenticationMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return OnboardAuthenticationCollectionViewCell.cellSize
    }
}

extension AuthenticationMainViewController: AuthenticationDelegate {
    func showHome() {
        self.showHomeVC()
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
    }
}


