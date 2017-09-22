//
//  MessagesChatViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class MessagesChatViewController: UIViewController {
    
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var linkProfileButton: UIButton!
    
    var chat: Chat?
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInformationsHeader()
        getAverageStars()
    }
    
    @IBAction func goToProfileView(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.chatToPofile, sender: self)
    }
    
    func setupInformationsHeader() {
        userImage.getUserImage(profile: profile!) { (success, msg) in
        }
        userName.text = profile?.fullName
    }
    
    func getAverageStars() {
        ProfileRequest.getAverageStars(profile: profile!) { (success, msg, averageStars) in
            if success {
                for i in 0 ..< averageStars {
                    self.starImages[i].image = UIImage(named: "chat_star_full")
                }
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ChatViewController {
            controller.presenter.chat = chat!
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            if let profile = profile {
                controller.presenter.setProfile(profile: profile)
            }
            
        }
    }

}
