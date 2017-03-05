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
    
    var boomerThingDelegate: UICollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNib()
    }
    
    func registerNib() {
        
        self.tableView.register(UINib(nibName: HomeCollectionHeader.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCollectionHeader.cellIdentifier)
         self.tableView.register(UINib(nibName: BoomerThingCollection.cellIdentifier, bundle: nil), forCellReuseIdentifier: BoomerThingCollection.cellIdentifier)
        
    }

    func loadHomeData(homeBoomerThingsData: [String: [BoomerThing]]) {
      
        self.homeBoomerThingsData = homeBoomerThingsData
        self.tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
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
        
        self.boomerThingDelegate = cell
        
        cell.selectionDelegate = self
        
        return cell
    }
    
}

extension HomeTableViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerData = (
            title: self.homeBoomerThingsData.keyAtIndex(index: section), isLocation: false)
        let locationsSectionNumber = 1
        if section == locationsSectionNumber {
            
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
            return 165
        } else {
            return 225
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(65)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let recomendationsSectionNumber = 2

        if section != recomendationsSectionNumber {
            return CGFloat(0)
        } else {
            return CGFloat(100)
        }
    }
}

extension HomeTableViewController: CollectionViewSelectionDelegate {
    
    func collectionViewDelegate(_ colletionViewDelegate: UICollectionViewDelegate, didSelectItemAt indexPath: IndexPath) {
        
        if colletionViewDelegate === boomerThingDelegate {
            self.performSegue(withIdentifier: "showDetailThing", sender: self)
        } else {
            
        }
        
    }
}


