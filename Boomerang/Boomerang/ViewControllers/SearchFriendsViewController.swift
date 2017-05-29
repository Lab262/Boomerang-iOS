//
//  SearchFriendsViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let tableViewTopInset: CGFloat = 10.0
    var presenter = SearchFriendsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        registerNib()
        setupViewDelegate()
        getProfiles()
        self.hideKeyboardWhenTappedAround()
    }
    
    func getProfiles() {
        self.view.loadAnimation()
        presenter.getProfiles()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureSearchBar() {
        searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
    }
    
    func registerNib(){
        tableView.registerNibFrom(SearchFriendsTableViewCell.self)
    }
    
    func generateTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        return cell
        
    }
    
    func generateSearchFriendCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        cell.presenter.profile = presenter.profiles[indexPath.row-1]
        cell.setupCellInformations()
        return cell
    }

}

extension SearchFriendsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return generateTitleCell(tableView, cellForRowAt: indexPath)
        default:
            return generateSearchFriendCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.profiles.count+1
    }
}

extension SearchFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 50.0
        default:
            return SearchFriendsTableViewCell.cellHeight * UIView.heightScaleProportion()
        }
    }
}

extension SearchFriendsViewController: SearchFriendsDelegate {
    func reload() {
        tableView.reloadData()
    }
    
    func showMessage(msg: String) {
        // message error
    }
    
    func loadingView() {
        self.view.loadAnimation()
    }
    
    func unloadingView() {
        self.view.unload()
    }
}
extension SearchFriendsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchFriendsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

