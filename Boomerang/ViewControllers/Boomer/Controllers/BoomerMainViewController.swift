//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerMainViewController: UIViewController {

    @IBOutlet weak var titleNavigation: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var user = User.current()!
    var type: TypePostEnum = TypePostEnum.need
    var titlePost = String()
    var presenter = HomePresenter()
    var timerAnimation: Timer?
    
    @IBOutlet weak var buttonNeed: UIButton!
    @IBOutlet weak var buttonHave: UIButton!
    @IBOutlet weak var buttonDonate: UIButton!
    
    @IBOutlet weak var iconNeedImageView: UIImageView!
    @IBOutlet weak var iconHaveImageView: UIImageView!
    @IBOutlet weak var iconDonateImageView: UIImageView!
    
    override func viewDidLoad() {
        configureDynamicFonts()
    }

    override func viewWillAppear(_ animated: Bool) {
        getProfilePhoto()
        self.resetIconImagesAnimations()
        animateIconImages()
        timerAnimation = Timer.scheduledTimer(withTimeInterval: 5.7, repeats: true) { (timer) in
            self.animateIconImages()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resetIconImagesAnimations()
    }
    
    func getProfilePhoto(){
        self.profileImage.getUserImage(profile: self.user.profile!) { (success, msg) in
            
        }
    }
    
    func configureDynamicFonts(){
        titleNavigation.setDynamicFont()
        buttonNeed.titleLabel?.setDynamicFont()
        buttonHave.titleLabel?.setDynamicFont()
        buttonDonate.titleLabel?.setDynamicFont()
    }
    
    func animateIconImages() {
        animateIconImage(iconImageView: iconNeedImageView, animationDuration: 0.7, prefixImage: "Preciso_000", countImages: 41)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { (timer) in
            self.animateIconImage(iconImageView: self.iconHaveImageView, animationDuration: 0.7, prefixImage: "Tenho_000", countImages: 47)
            timer.invalidate()
            Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { (timer) in
                self.animateIconImage(iconImageView: self.iconDonateImageView, animationDuration: 0.9, prefixImage: "doar_000", countImages: 31)
                timer.invalidate()
            }
        }
    }
    
    func animateIconImage(iconImageView: UIImageView, animationDuration: TimeInterval, prefixImage: String, countImages: Int){
        
        var arrayImages = [UIImage]()
        for i in 0..<countImages {
            if let image = UIImage(named: prefixImage + "\(i)"){
                arrayImages.append(image)
            }
        }
        
        iconImageView.animationImages = arrayImages
        iconImageView.animationDuration = animationDuration
        iconImageView.animationRepeatCount = 1
        iconImageView.startAnimating()
        
    }
    
    func resetIconImagesAnimations(){
        self.timerAnimation?.invalidate()
        self.iconNeedImageView.stopAnimating()
        self.iconHaveImageView.stopAnimating()
        self.iconDonateImageView.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goThrowVC") {
            let throwVC = segue.destination as! ThrowViewController
            throwVC.typeVC = type
            throwVC.titleHeader = titlePost
        }
    }
    
    @IBAction func iHaveAction(_ sender: Any) {
        type = .have
        titlePost = TypePostTitles.have
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
       
    }
    
    
    @IBAction func iNeedaction(_ sender: Any) {
        type = .need
         titlePost = TypePostTitles.need
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    @IBAction func donateAction(_ sender: Any) {
        type = .donate
        titlePost = TypePostTitles.donate
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
        
    }
    @IBAction func goToProfile(_ sender: Any) {
        TabBarController.mainTabBarController.uiTabBarController.selectedIndex = 1
        TabBarController.mainTabBarController.changeStatesButtons(tag: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    

}
