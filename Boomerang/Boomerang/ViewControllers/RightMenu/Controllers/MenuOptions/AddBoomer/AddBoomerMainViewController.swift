//
//  NotificationsMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class AddBoomerMainViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var cellDatas = [BoomerCellData]()
    
    func loadDummyData() {
        self.cellDatas = [
        BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
        BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY")
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDummyData()
        self.registerNibs()
    }
    
    func registerNibs() {
        let nib = UINib(nibName: AddBoomerCell.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: AddBoomerCell.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}


extension AddBoomerMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddBoomerCell.cellIdentifier, for: indexPath) as! AddBoomerCell
        cell.boomerCellData = self.cellDatas[indexPath.row]
        return cell;
    }

}
