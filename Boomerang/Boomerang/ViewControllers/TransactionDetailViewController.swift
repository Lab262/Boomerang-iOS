//
//  TransactionDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    let tableViewTopInset: CGFloat = 131.0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
    }
    
    func registerNib(){
        tableView.registerNibFrom(LinkPostTableViewCell.self)
        tableView.registerNibFrom(TransactionDetailTableViewCell.self)
    }
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
    }
    
    func generateLinkPostCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkPostTableViewCell.identifier, for: indexPath) as! LinkPostTableViewCell
        
        return cell
    }
    
    func generateTransactionDetailCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailTableViewCell.identifier, for: indexPath) as! TransactionDetailTableViewCell
        
        return cell
    }
    
}

extension TransactionDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            return generateLinkPostCell(tableView, cellForRowAt: indexPath)
        case 1:
            return generateTransactionDetailCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
}

extension TransactionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return LinkPostTableViewCell.cellHeight
        case 1:
            return TransactionDetailTableViewCell.cellHeight
        default:
            return 0
        }
    }
}
