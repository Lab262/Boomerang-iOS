//
//  NotificationViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: EmptyView!
    
    @IBOutlet weak var emptyImageView: UIImageView!
    
    var tableViewLeftInset: CGFloat = 15
    var tableViewRightInset: CGFloat = 15
    var presenter = NotificationPresenter()
    let tableViewBottomInset = CGFloat(80.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setPresenterDelegate()
        getNotifications()
        configureEmptyView()
        setupSubscribes()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
    }
    
    func setupSubscribes() {
        presenter.subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureEmptyView(){
        self.emptyView.emptyButton.isHidden = true
        self.emptyView.isHidden = true
        self.emptyImageView.isHidden = true
    }

    func setPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func getNotifications(){
        presenter.requestNotifications()
    }
    
    func registerNib(){
        tableView.registerNibFrom(NotificationTableViewCell.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ThingDetailViewController {
            let selectedIndex = tableView.indexPathForSelectedRow
            destinationVC.presenter.post = presenter.getNotifications()[selectedIndex!.row].post!
        }
        
        if let destinationVC = segue.destination as? TransactionDetailViewController {
            let selectedIndex = tableView.indexPathForSelectedRow
            destinationVC.presenter.scheme = presenter.getNotifications()[selectedIndex!.row].scheme!
        }
    }
}

extension NotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        
        cell.presenter.setNotification(notification: presenter.getNotifications()[indexPath.row])
        cell.setupCellInformations()
        
        if indexPath.row == presenter.getNotifications().endIndex-1 {
            cell.backgroundSupportView.isHidden = true
        } else {
            cell.backgroundSupportView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getNotifications().count
    }
}

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = presenter.getNotifications()[indexPath.row].scheme {
            performSegue(withIdentifier: SegueIdentifiers.notificationToSchemeDetail, sender: self)
        } else {
            performSegue(withIdentifier: SegueIdentifiers.notificationToDetailThing, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NotificationTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

extension NotificationViewController: ViewDelegate {

    func reload() {
        if presenter.getNotifications().count == 0{
            self.emptyView.isHidden = false
            self.emptyImageView.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.emptyView.isHidden = true
            self.emptyImageView.isHidden = true
            self.tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    func showMessageError(msg: String) {
        // messageError
    }
}
