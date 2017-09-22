//
//  SearchFriendsViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let tableViewTopInset: CGFloat = 10.0
    var presenter = SearchFriendsPresenter()
    let tableViewBottomInset = CGFloat(80.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupViewDelegate()
        getProfiles()
        self.hideKeyboardWhenTappedAround()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
        self.tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    func getProfiles() {
        presenter.getProfiles()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
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
        cell.setupCellInformations(fetchAlreadyFollowing: true)
        return cell
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ProfileMainViewController {
            controller.presenter.setProfile(profile: presenter.profiles[tableView.indexPathForSelectedRow!.row-1])
        }
    }
}

extension SearchFriendsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            presenter.getProfiles()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
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
        
        if indexPath.row >= 1 {
            performSegue(withIdentifier: SegueIdentifiers.searchFriendsToProfile, sender: self)
        }
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
    
    func startFooterLoading() {
        tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
    }
    
    func finishFooterLoading() {
        self.tableView.tableFooterView?.unload()
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


extension SearchFriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.searchProfiles(searchString: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}

