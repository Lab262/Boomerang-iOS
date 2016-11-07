//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class HomeMainViewController: UIViewController {

    internal var homeTableViewController: HomeTableViewController!
    internal var homeBoomerThingsData = [String: [BoomerThing]]()

    @IBAction func showMenu(_ sender: Any) {
        
        TabBarController.showMenu()
    }

    func loadDummyData() {
        let boomerThing1 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Preciso de um app para o boomerang", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Amanda Elys")
        let boomerThing2 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Ofereço um longboard freehide", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Thiago Bernardes")
        let boomerThing3 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Preciso de um mangá", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Huallyd Smadi")
        let boomerThing4 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Ofereço aulas de como ser foda", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Janaina na aaaa aaa")
        
        homeBoomerThingsData = [
            "Meus amigos" : [boomerThing1, boomerThing2, boomerThing3],
            "Brasília - DF" : [boomerThing4,boomerThing2, boomerThing3],
            "Recomendados para voce" : [boomerThing3, boomerThing2],

        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDummyData()
        self.homeTableViewController.loadHomeData(homeBoomerThingsData: homeBoomerThingsData)
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? HomeTableViewController {
            self.homeTableViewController = controller
        }
    }
    
}
