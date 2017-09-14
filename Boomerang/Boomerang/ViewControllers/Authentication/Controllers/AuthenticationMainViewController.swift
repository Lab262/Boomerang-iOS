
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
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var facebookButton: UIButton!
    var presenter = AuthenticationPresenter()
    var pageIndicatorView: PageIndicatorView?
    let spaceCells: CGFloat = 2
    let sizeCells: Int = 8
    @IBOutlet weak var viewPages: UIView!
    let defaultTextTitleWelcome = "Bem vindo"
    let defaultTextDescriptionWelcome = " a rede social mais amorzinho que você respeita"
    let defaultSizeFontWelcomeLabel:CGFloat = 14
    let allText = ["Bem vindo a rede social mais amorzinho que você respeita"," Aqui todo mundo se conhece! Nossa rede é feita de amigos para amigos.","Entre com o Facebook para conseguir o código boomer"]
    let allImages = [#imageLiteral(resourceName: "ic_heart_auth"),#imageLiteral(resourceName: "ic_friends_auth"),#imageLiteral(resourceName: "ic_padlock_auth")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomLabel()
        setupViewDelegate()
        self.registerNibs()
        self.setUpCollectionView()
        initializePageIndicatorView()
        
    }
    
    func initializePageIndicatorView(){
        pageIndicatorView = PageIndicatorView(frame: viewPages.frame)
        pageIndicatorView?.delegate = self
        viewPages.addSubview(pageIndicatorView!)
        pageIndicatorView?.centerXAnchor.constraint(equalTo: viewPages.centerXAnchor).isActive = true
        pageIndicatorView?.centerYAnchor.constraint(equalTo: viewPages.centerYAnchor).isActive = true
        pageIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateCell(){
        pageCollectionView.reloadData()
        pageIndicatorView?.reload()
    }
    
    func setUpCollectionView() {
     
        let flowLayout = pageCollectionView.collectionViewLayout as?CenterCellCollectionViewFlowLayout
        flowLayout?.centerOffset = CGPoint(x: pageCollectionView.frame.width * 0.8, y: 0)
        
        let margin: CGFloat = 40.0
        
        flowLayout?.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        flowLayout?.minimumLineSpacing = margin
    }
    
    
    
    func setupViewDelegate() {
        presenter.setViewDelegate(delegate: self)
    }
    
    func registerNibs (){
        pageCollectionView.registerNibFrom(PageCollectionViewCell.self)
    }
    
    func setupCustomLabel(){
        let textWelcomeLabel = NSMutableAttributedString(string: defaultTextTitleWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratBlack(size: defaultSizeFontWelcomeLabel)])
        
        let textWelcomeDescriptionLabel = NSMutableAttributedString(string: defaultTextDescriptionWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratLight(size: defaultSizeFontWelcomeLabel)])
        
        textWelcomeLabel.append(textWelcomeDescriptionLabel)
        //self.welcomeLabel.attributedText = textWelcomeLabel
    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
       
        PromoCodeController.presentMe(inParent: self, delegate: self)
        
        //self.presenter.loginFacebook()
        
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

extension AuthenticationMainViewController{
    
    
    func generatePageCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as! PageCollectionViewCell
        cell.imagePageView.image = allImages[indexPath.row]
        cell.titleText.text = allText[indexPath.row]
        
        return cell
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
}
extension AuthenticationMainViewController: PromoCodeRequestDelegate {
    func afterValidateCode() {
        self.presenter.loginFacebook()
    }
}
extension AuthenticationMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    

        let flowLayout = (self.pageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let indexPath = pageCollectionView.indexPathForItem(at: self.pageCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: pageCollectionView.frame.width/2, y: 0))
        
        
        if UIScreen.main.bounds.width == 320.0 {
            let indexPath2 = pageCollectionView.indexPathForItem(at: self.pageCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: pageCollectionView.frame.width/2, y: 0)+CGPoint(x: 0, y: 19.5))
            
            if let index = indexPath2 {
                pageIndicatorView?.selectedPage = index.row
            }
        }
        
        if UIScreen.main.bounds.width == 414.0 {
            let indexPath3 = pageCollectionView.indexPathForItem(at: self.pageCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: pageCollectionView.frame.width/2, y: 0)+CGPoint(x: 0, y: 14))
            
            if let index = indexPath3 {
                pageIndicatorView?.selectedPage = index.row
            }
        }
        
        
        
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
        }
    }
    

}

extension AuthenticationMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return generatePageCell(collectionView, cellForItemAt:indexPath)
    }
    
    

}
extension AuthenticationMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: PageCollectionViewCell.cellSize.width * UIView.heightScaleProportion(), height: PageCollectionViewCell.cellSize.height * UIView.heightScaleProportion())
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
  
}

extension AuthenticationMainViewController: PageIndicatorViewDelegate {
    
    var numberOfPages: Int {
        return 3
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
