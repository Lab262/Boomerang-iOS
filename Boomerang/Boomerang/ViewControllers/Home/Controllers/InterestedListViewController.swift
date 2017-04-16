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
    var presenter: InterestedPresenter = InterestedPresenter()
    let tableViewTopInset: CGFloat = 94.0
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
        presenter.setControllerDelegate(controller: self)
        self.view.loadAnimation()
        updateInteresteds()
    }
    
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    func registerNib(){
        tableView.registerNibFrom(InterestedTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.white
        return viewIndicator
    }
    
    func updateInteresteds(){
        presenter.updateInteresteds()
    }
    
    func createScheme(_ sender: UIButton) {
        presenter.setInterested(interested: presenter.getInteresteds()[sender.tag])
        presenter.createScheme()
    }
}

extension InterestedListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InterestedTableViewCell.identifier, for: indexPath) as! InterestedTableViewCell
        
        cell.presenter.setInterested(interested: presenter.getInteresteds()[indexPath.row])
        cell.initializeSchemeButton.tag = indexPath.row
        cell.initializeSchemeButton.addTarget(self, action: #selector(createScheme(_:)), for: .touchUpInside)
        cell.loadViewCell()
        cell.countLabel.text = "\(indexPath.row)"
        
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

extension InterestedListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
            
            updateInteresteds()
        }
    }
}

extension InterestedListViewController: ViewDelegate {
    
    func reload() {
        if presenter.getInteresteds().count != presenter.getCurrentInterestedsCount() {
            tableView.reloadData()
        }
        
        self.view.unload()
        tableView.tableFooterView?.unload()
    }
    
    func showMessageError(msg: String) {
        self.view.unload()
        self.present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
    }
}



