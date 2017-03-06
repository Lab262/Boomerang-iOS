//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse

class HomeMainViewController: UIViewController {

    internal var homeTableViewController: HomeTableViewController!
    internal var homeBoomerThingsData = [String: [BoomerThing]]()

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var greetingText: UILabel!
    
    var user = ApplicationState.sharedInstance.currentUser
    
    @IBAction func showMenu(_ sender: Any) {
        
        TabBarController.showMenu()
    }

    func loadDummyData() {
        let boomerThing1 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Preciso de um app para o boomerang", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Amanda Elys", thingType: .need)
        let boomerThing2 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Ofereço um longboard freehide", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Thiago Bernardes", thingType: .have)
        let boomerThing3 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Um mangá", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Huallyd Smadi", thingType: .need)
        let boomerThing4 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Aulas de como ser foda", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Janaina na aaaa aaa", thingType: .experience)
        
        homeBoomerThingsData = [
            "Meus amigos" : [boomerThing1, boomerThing2, boomerThing3],
            "Brasília - DF" : [boomerThing4,boomerThing2, boomerThing3],
            "Recomendados para voce" : [boomerThing3, boomerThing2,boomerThing4],

        ]
    }
    

    func setUserInformationsInHUD(){
        
        greetingText.text = "Olar, \(user!.firstName!)"
        
        guard let image = user?.profileImage else {
            profileImage.loadAnimation()
            
            UserRequest.getProfilePhoto(completionHandler: { (success, msg, photo) in
                
                if success {
                    self.user?.profileImage = photo
                    self.profileImage.image = photo
                    self.profileImage.unload()
                } else {
                    
                }
            })
            
            return
        }
        
        profileImage.image = image
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUserInformationsInHUD()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.loadDummyData()
        self.homeTableViewController.loadHomeData(homeBoomerThingsData: homeBoomerThingsData)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? HomeTableViewController {
            self.homeTableViewController = controller
        }
    }
    
}
