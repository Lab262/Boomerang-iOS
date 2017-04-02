//
//  InterestedListViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class InterestedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarExtensionView: ThingNavigationBar!
    var presenter: InterestedPresenter = InterestedPresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setControllerDelegate(controller: self)
        presenter.getInterestedsByPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarExtensionView.thingNameLabel.isHidden = true
        navigationBarExtensionView.titleTransactionLabel.isHidden = true
        navigationBarExtensionView.typeImage.isHidden = true
    }
    
    
}

extension InterestedListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InterestedTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getInteresteds().count
    }
}

extension InterestedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return InterestedTableViewCell.cellHeight
    }
}

extension InterestedListViewController: ViewDelegate {
    
    func reload() {
        
    }
    
    func showMessageError(msg: String) {
        
    }
}



