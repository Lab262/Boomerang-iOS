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
    var presenter = TransactionFilterPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        registerObservers()
        presenter.setViewDelegate(view: self)
    }
    
    func registerNib(){
        tableView.registerNibFrom(TransactionTableViewCell.self)
    }
    
    func registerObservers(){
         NotificationCenter.default.addObserver(self, selector: #selector(updateSchemes(_:)), name: NSNotification.Name(rawValue: NotificationKeys.updateSchemes), object: nil)
    }
    
    func updateSchemes (_ notification: Notification) {
        if let schemes = notification.object as! [Scheme]? {
            presenter.setSchemes(schemes: schemes)
            reload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? TransactionDetailViewController {
            //segmentControlButtonDelegate = segmentVC
            //segmentVC.segmentControlPageDelegate = self
        }
    }
}

extension LoanTransactionViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.presenter.setScheme(scheme: presenter.getSchemes()[indexPath.row])
        cell.updateCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getSchemesFor(postType: .donate).count
    }
}

extension LoanTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.transactionToProfile, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TransactionTableViewCell.cellHeight
    }
}

extension LoanTransactionViewController: ViewDelegate {
    func reload() {
        tableView.reloadData()
    }
    func showMessageError(msg: String) {
        // error
    }
}

