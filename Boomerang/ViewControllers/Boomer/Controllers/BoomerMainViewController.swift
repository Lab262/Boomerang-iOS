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
    
    @IBOutlet weak var buttonNeed: UIButton!
    @IBOutlet weak var buttonHave: UIButton!
    @IBOutlet weak var buttonDonate: UIButton!
    
    override func viewDidLoad() {
        configureDynamicFonts()
    }

    override func viewWillAppear(_ animated: Bool) {
        getProfilePhoto()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    

}
