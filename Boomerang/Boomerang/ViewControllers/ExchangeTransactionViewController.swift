//
//  ExchangeTransactionViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ExchangeTransactionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter = TransactionFilterPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
    }
    
    func registerNib(){
        tableView.registerNibFrom(TransactionTableViewCell.self)
    }

}

extension ExchangeTransactionViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getSchemes().count
    }
}

extension ExchangeTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TransactionTableViewCell.cellHeight
    }
}

