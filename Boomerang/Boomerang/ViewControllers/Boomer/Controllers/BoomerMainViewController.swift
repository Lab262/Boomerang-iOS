//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

//enum PostType {
//    case need: "need"
//    case have: "have"
//    case donate: "donate"
//}
class BoomerMainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var user = ApplicationState.sharedInstance.currentUser
    var type: TypePost = TypePost.need
    var titlePost = String()
    var presenter = HomePresenter()
    
    @IBOutlet weak var buttonDonateImage: UIImageView!
    @IBOutlet weak var buttonHaveImage: UIImageView!
    @IBOutlet weak var buttonNeedImage: UIImageView!
    @IBAction func showMenu(_ sender: Any) {
        
        //TabBarController.showMenu()
    }
    override func viewDidLoad() {
//        setUserInformationsInHUD()
     
    }
    override func viewDidAppear(_ animated: Bool) {
           self.animationButtos()
    }
    
    func animationButtos(){
     
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getProfilePhoto()

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
        titlePost = "Tenho"
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
       
    }
    
    
    @IBAction func iNeedaction(_ sender: Any) {
        type = .need
         titlePost = "Preciso"
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    @IBAction func donateAction(_ sender: Any) {
        type = .donate
        titlePost = "Doação"
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
        
    }
    
    
    @IBAction func experienceAction(_ sender: Any) {
        
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
    func getProfilePhoto(){
        self.profileImage.getUserImage(profile: self.user!.profile!) { (success, msg) in
            
        }
        
//        guard let image = user?.profileImage else {
//            profileImage.loadAnimation()
//            return
//        }
//        
//        profileImage.image = image
        
    }

}
//extension BoomerMainViewController {
//    
//    func setUserInformationsInHUD(){
//        
//        self.profileImage.loadAnimation()
//        presenter.getUserImage { (success, msg, image) in
//            if success {
//                self.profileImage.unload()
//                self.profileImage.image = image
//                self.presenter.getUser().profileImage = image
//            } else {
//                self.profileImage.unload()
//            }
//        }
//    }
//}

