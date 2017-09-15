//
//  NotificationsMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SwiftyJSON


class AddBoomerMainViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter = AddBoomerPresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        setupSearchBarConfiguration()
        setupViewDelegate()
        getFacebookFriends()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func registerNibs() {
        tableView.registerNibFrom(SearchFriendsTableViewCell.self)
    }
    
    func getFacebookFriends() {
        presenter.getFriendsByFacebook()
    }
    
    func setupSearchBarConfiguration() {
        searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
        searchBar.setBackgroundSearchBarColor(color: UIColor.backgroundSearchColor)
        searchBar.setCursorSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setPlaceholderSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setTextSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setIconSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setClearIconSearchBarColor(color: UIColor.textSearchColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
}


extension AddBoomerMainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        
        cell.presenter.profile = presenter.profiles[indexPath.row]
        cell.setupCellInformations()
        
        return cell
    }
    
    func followUser() {
        
    }
}

extension AddBoomerMainViewController: AddBoomerDelegate {
    
    func unloadView() {
        view.unload()
    }
    
    func loadingView() {
        view.loadAnimation()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessage(msg: String) {
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: msg, negativeAction: "Ok") { (isPositive) in
            self.dismiss(animated: true, completion: nil)
        }    }
}
