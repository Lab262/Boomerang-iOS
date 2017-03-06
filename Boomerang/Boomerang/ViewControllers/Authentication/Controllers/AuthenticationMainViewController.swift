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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            
            if let user = user {
                if user.isNew {
                    self.updateUserByFacebook()
                } else {
                    self.showHomeVC()
                }
            }
        }


    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        
       

        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error == nil {
                self.view.loadAnimation()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if (result?.isCancelled)! {
                    self.view.unload()
                    return
                }
                
                if(fbloginresult.grantedPermissions.contains("email")) {
                    
                    self.returnUserData()
                    
                }
            } else {
                
            }
            
        }
    }
    
    func getPhotoOfFacebookInPFFile (userId: String) -> PFFile? {
        
        var photoInPFFile: PFFile?
        
        if let url = URL(string: "https://graph.facebook.com/" + userId + "/picture?type=large") {
            do {
                let contents = try Data(contentsOf: url)
                 photoInPFFile = PFFile(data: contents)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
        return photoInPFFile
        
    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil {
                self.view.loadAnimation()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if (result?.isCancelled)! {
                    self.view.unload()
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                }
            }
        }
    }

    func updateUserByFacebook(){
        
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        let newUser = PFUser.current()!
        
        userDetails!.start { (connection, result, error) -> Void in
            
            if error != nil {
                print ("ERRO")
            }
            
            if result != nil {
                if let data = result as? [String: Any] {
                    
                    if let firstName = data["first_name"] as? String {
                        newUser.setObject(firstName, forKey: "username")
                        newUser.setObject(firstName, forKey: "firstName")
                    }
                    
                    if let lastName = data["last_name"] as? String {
                        newUser.setObject(lastName, forKey: "lastName")
                    }
                    
                    if let email = data ["email"] as? String {
                        newUser.setObject(email, forKey: "email")
                    }
                    
                    if let userId = data["id"] as? String {
                        if let userPhoto = self.getPhotoOfFacebookInPFFile(userId: userId) {
                            newUser.setObject(userPhoto, forKey: "photo")
                        }
                    }
                }
                
                newUser.saveInBackground(block: { (success, error) in
                    if success {
                        self.showHomeVC()
                    }
                })
            }
        }
    }

    
    
    func showHomeVC() {
        
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcToShow = storyboard.instantiateInitialViewController()!
        self.present(vcToShow, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
extension AuthenticationMainViewController {
    
    func returnUserData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    let userName = "\(data["first_name"] as! String) \(data["last_name"] as! String)"
                    
                    UserRequest.loginUserWithFacebook(id: data["id"] as! String, email: data["email"] as! String,userName: userName, mediaType:SocialMediaType.facebook.rawValue, completionHandler: { (success, msg, user) in
                        
                        if success {
                            self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
                            
                        }else {
                            self.view.unload()
                            self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
                        }                    })
                    
                }
            })
        }

    }


   
}


