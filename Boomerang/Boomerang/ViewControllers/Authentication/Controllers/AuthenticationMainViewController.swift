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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    
    let defaultTextTitleWelcome = "Bem vindo"
    let defaultTextDescriptionWelcome = " a rede social mais amorzinho que você respeita"
    let defaultSizeFontWelcomeLabel:CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomLabel()
    }
    
    func setupCustomLabel(){
        let textWelcomeLabel = NSMutableAttributedString(string: defaultTextTitleWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratBlack(size: defaultSizeFontWelcomeLabel)])
        let textWelcomeDescriptionLabel = NSMutableAttributedString(string: defaultTextDescriptionWelcome, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.montserratLight(size: defaultSizeFontWelcomeLabel)])
        
        textWelcomeLabel.append(textWelcomeDescriptionLabel)

        self.welcomeLabel.attributedText = textWelcomeLabel
    }
    
    func getPhotoOfFacebookInPFFile (userId: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ file: PFFile?) -> ()) {
        var photoInPFFile: PFFile?
        
        DispatchQueue.main.async {
            if let url = URL(string: "https://graph.facebook.com/" + userId + "/picture?type=large") {
                do {
                    let contents = try Data(contentsOf: url)
                    photoInPFFile = PFFile(data: contents)
                    completionHandler(true, "success", photoInPFFile)
                } catch {
                    // contents could not be loaded
                    completionHandler(false, "error", nil)
                }
            } else {
                completionHandler(false, "error", nil)
            }
        }
    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
        let permissions = ["public_profile", "email","user_friends"]
        
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

    func updateUserByFacebook(){
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        let newUser = PFUser.current()!
        let profile = PFObject(className: "Profile")
        userDetails!.start { (connection, result, error) -> Void in
            
            if error != nil {
                print ("ERRO")
            }
            
            if result != nil {
                if let data = result as? [String: Any] {
                    
                    if let firstName = data["first_name"] as? String {
                        newUser.setObject(firstName, forKey: "username")
                        newUser.setObject(firstName, forKey: "firstName")
                        profile.setObject(firstName, forKey: "firstName")
                    }
                    
                    if let lastName = data["last_name"] as? String {
                        newUser.setObject(lastName, forKey: "lastName")
                        profile.setObject(lastName, forKey: "lastName")
                    }
                    
                    if let email = data ["email"] as? String {
                        newUser.setObject(email, forKey: "email")
                        profile.setObject(email, forKey: "email")
                    }
                    
                    if let userId = data["id"] as? String {
                        self.getPhotoOfFacebookInPFFile(userId: userId, completionHandler: { (success, msg, userPhoto) in
                            if success {
                                profile.setObject(userPhoto!, forKey: "photo")
                                newUser.setObject(userPhoto!, forKey: "photo")
                                newUser.setObject(profile, forKey: "profile")
                                newUser.saveInBackground(block: { (success, error) in
                                    if success {
                                        self.showHomeVC()
                                    } else {
                                        print ("ERROR SAVE")
                                    }
                                })
                            } else {
                                print ("ERROR PHOTO")
                            }
                        })
                    }
                }
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
                            self.present(ViewUtil.alertControllerWithTitle(title: "Erro", withMessage: msg), animated: true, completion: nil)
                        }                    })
                    
                }
            })
        }

    }


   
}


