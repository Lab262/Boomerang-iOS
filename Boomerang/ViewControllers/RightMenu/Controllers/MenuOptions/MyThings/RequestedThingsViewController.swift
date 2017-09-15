//
//  FavoriteHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


class RequestedThingsViewController: LendingThingsViewController {
    
    override func loadData() {
        
        self.thingsData = [
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Discos Vinial", dataTitle: "Daisy Klein", dataSubDescription: "Devolver 20/ 02 / 2017" ),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Carro I30", dataTitle: "Felipe Perius",dataSubDescription: "Devolução 10/ 03 / 2017")
        ]

        
    }
    
}


