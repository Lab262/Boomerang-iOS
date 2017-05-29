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
    @IBOutlet weak var emptyView: EmptyView!
    
    var presenter = TransactionFilterPresenter()
    var notificationKey: String!
    let tableViewBottomInset = CGFloat(80.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        registerObservers()
        presenter.setViewDelegate(view: self)
        self.emptyView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
    }
    
    func registerNib(){
        tableView.registerNibFrom(TransactionTableViewCell.self)
    }
    
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateSchemes(_:)), name: NSNotification.Name(rawValue: notificationKey), object: nil)
    }
    
    func updateSchemes (_ notification: Notification) {
        if let schemes = notification.object as! [Scheme]? {
            presenter.setSchemes(schemes: schemes)
            reload()
            if presenter.getSchemesFor(postCondition: .exchange).count == 0{
                self.tableView.isHidden = true
                self.emptyView.isHidden = false
            }else{
                self.tableView.isHidden = false
                self.emptyView.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TransactionDetailViewController {
            
            destinationVC.presenter.scheme = presenter.getSchemesFor(postCondition: .exchange)[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ExchangeTransactionViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.presenter.scheme = presenter.getSchemesFor(postCondition: .exchange)[indexPath.row]
        cell.updateCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getSchemesFor(postCondition: .exchange).count
    }
}

extension ExchangeTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: SegueIdentifiers.transactionToProfile, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TransactionTableViewCell.cellHeight*UIView.heightScaleProportion()
    }
}

extension ExchangeTransactionViewController: ViewDelegate {
    func reload() {
        tableView.reloadData()
    }
    func showMessageError(msg: String) {
        
    }
}


