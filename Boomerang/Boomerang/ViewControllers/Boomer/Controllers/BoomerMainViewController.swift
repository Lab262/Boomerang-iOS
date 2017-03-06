//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerMainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    var user = ApplicationState.sharedInstance.currentUser

    @IBAction func showMenu(_ sender: Any) {
        
        TabBarController.showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfilePhoto()
    }
    
    func getProfilePhoto(){
        
        guard let image = user?.profileImage else {
            profileImage.loadAnimation()
            
            user?.getMultipleDataFrom(keys: ["photo", "photo"], completionHandler: { (success, msg, datas) in
                
            })
            
//            UserRequest.getProfilePhoto(user: user!, completionHandler: { (success, msg, photo) in
//                
//                if success {
//                    self.user?.profileImage = photo
//                    self.profileImage.image = photo
//                    self.profileImage.unload()
//                } else {
//                    
//                }
//            })
            
            return
        }
        
        profileImage.image = image

    }
    
    @IBAction func iHaveAction(_ sender: Any) {
        
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
        
    }
    
    
    @IBAction func iNeedaction(_ sender: Any) {
        
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    @IBAction func donateAction(_ sender: Any) {
        
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    
    @IBAction func experienceAction(_ sender: Any) {
        
        self.performSegue(withIdentifier:"goThrowVC", sender:nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
}
