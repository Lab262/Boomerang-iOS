//
//  AuthenticationMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FalconFrameworkIOSSDK
import FacebookLogin
import  FacebookCore
import FacebookShare


class AuthenticationMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signInAction(_ sender: Any) {
        self.showHomeVC()

    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        self.showHomeVC()

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

    func showHomeVC() {
        
        DefaultsHelper.sharedInstance.email = "thiago@lab262.com"
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
                    
                    let socialMediaId = data["id"] as! String
                    let email = data["email"] as! String
                    let name = "\(data["first_name"] as! String) \(data["last_name"])"
                    
                    self.getListFriends()
                    
                    FFAuthRequests.loginUserWithSocialMedia(socialMediaId: socialMediaId, email: email, name: name, socialMediaType: .facebook, socialMediaPasswordServerSecret: "AQWgd$j[QGe]Bh.Ugkf>?B3y696?2$#B2xwfN3hrVhFrE348g", autoStoreAuthTokenData: true) { (error, tokenReturnData) in
                        
                        if error == nil,
                            let user = tokenReturnData?["user"] as? NSDictionary,
                            let userId = user["id"] as? Int {
                           
                        } else {
                            self.view.unload()
                            self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: error!.detail!), animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    func getListFriends(){
           
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error: \(error)")
//            }
//            else
//            {
//                print("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
//                let userID : NSString = result.valueForKey("id") as! NSString
//                print("User Email is: \(userID)")
//                
//                
//                
//            }
//        })
    
    }
    

   
}


