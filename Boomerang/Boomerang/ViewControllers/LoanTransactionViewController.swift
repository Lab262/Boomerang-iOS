//
//  LoanTransactionViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class LoanTransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: EmptyView!
    var presenter = TransactionFilterPresenter()
    var notificationKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        registerObservers()
        presenter.setViewDelegate(view: self)
        self.emptyView.isHidden = true
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
            if presenter.getSchemesFor(postCondition: .loan).count == 0{
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
            
            destinationVC.presenter.scheme = presenter.getSchemes()[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension LoanTransactionViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.presenter.scheme = presenter.getSchemesFor(postCondition: .loan)[indexPath.row]

            //presenter.getSchemes()[indexPath.row]
        cell.updateCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getSchemesFor(postCondition: .loan).count
    }
}

extension LoanTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: SegueIdentifiers.transactionToProfile, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TransactionTableViewCell.cellHeight*UIView.heightScaleProportion()
    }
}

extension LoanTransactionViewController: ViewDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessageError(msg: String) {
        
    }
}

