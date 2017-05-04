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
    
    var chat: Chat?
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInformationsHeader()
    }
    
    func setupInformationsHeader() {
        userName.text = profile?.fullName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ChatViewController {
            controller.presenter.setChat(chat: chat!)
        }
    }

}
