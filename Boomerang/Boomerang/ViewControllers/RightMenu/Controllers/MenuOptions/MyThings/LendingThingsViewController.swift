//
//  AllHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class LendingThingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var thingsData = [BoomerCellData]()
    
    func loadData() {
        self.thingsData = [
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Guitarra Fender", dataTitle: "Shirley Schimidt", dataSubDescription: "Devolução 20/ 01 / 2016" ),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Camera Vintage", dataTitle: "Marcos Morais",dataSubDescription: "Devolução 20/ 01 / 2016")
        ]
    }

    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: BoomerMyThingCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: BoomerMyThingCell.cellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.registerNibs()
    }

}

extension LendingThingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BoomerMyThingCell.cellIdentifier, for: indexPath) as! BoomerMyThingCell
        cell.boomerCellData = self.thingsData[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

           return self.thingsData.count
        }
        
}



