//
//  HomeTableViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class HomeTableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    internal var homeBoomerThingsData = [String: [BoomerThing]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNib()
        self.tableView.sectionFooterHeight = 0.0;
    }
    
    func registerNib() {
        
        self.tableView.register(UINib(nibName: HomeCollectionHeader.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCollectionHeader.cellIdentifier)
         self.tableView.register(UINib(nibName: BoomerThingCollection.cellIdentifier, bundle: nil), forCellReuseIdentifier: BoomerThingCollection.cellIdentifier)
        
    }

    func loadHomeData(homeBoomerThingsData: [String: [BoomerThing]]) {
      
        self.homeBoomerThingsData = homeBoomerThingsData
        self.tableView.reloadData()
    }

    
}

extension HomeTableViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.homeBoomerThingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BoomerThingCollection.cellIdentifier,
            for: indexPath) as! BoomerThingCollection
        cell.thingsData = self.homeBoomerThingsData.dataAtKeyAtIndex(
            index: indexPath.section) as! [BoomerThing]
        return cell
    }
    
}

extension HomeTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerData = (
            title: self.homeBoomerThingsData.keyAtIndex(index: section), isLocation: false)
        let recomendationsSectionNumber = 1
        if section == recomendationsSectionNumber {
            
            headerData.isLocation = true
        } else {
            headerData.isLocation = false

        }
        
        let header = tableView.dequeueReusableCell(withIdentifier:HomeCollectionHeader.cellIdentifier) as! HomeCollectionHeader
        header.headerData = headerData
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section != 2 {
            return CGFloat(165)
        } else {
            return CGFloat(195)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(65)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
}

