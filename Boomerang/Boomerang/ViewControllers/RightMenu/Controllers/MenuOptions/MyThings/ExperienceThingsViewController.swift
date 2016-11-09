//
//  UnreadHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ExperienceThingsViewController: LendingThingsViewController {
    
    override func loadData() {
        self.thingsData = [
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Aulas de Ninjutso", dataTitle: "Huallyd Smadi", dataSubDescription: "No dia 13/ 04 / 2017" ),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Workshop como ser top", dataTitle: "Janaina Araújo",dataSubDescription: "No dia 12/ 02 / 2017")
        ]
    }
}


