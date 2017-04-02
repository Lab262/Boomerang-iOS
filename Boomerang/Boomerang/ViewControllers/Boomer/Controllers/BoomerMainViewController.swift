//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

enum PostType {
    case need
    case have
    case donate
}
class BoomerMainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var user = ApplicationState.sharedInstance.currentUser
    var type: PostType = PostType.need
    var titlePost = String()
    @IBAction func showMenu(_ sender: Any) {
        
        //TabBarController.showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.getProfilePhoto()
        
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
        
        guard let image = user?.profileImage else {
            profileImage.loadAnimation()
            
            
            
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

}
