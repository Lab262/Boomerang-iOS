//
//  RecommendedViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 15/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController {

    @IBOutlet weak var navigationBar: IconNavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var presenter = RecommendedPresenter()
    let tableViewTopInset: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureNavigationBar()
        registerNib()
        setupViewDelegate()
        fetchFriends()
    }
    
    func configureNavigationBar() {
        navigationBar.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViewDelegate(){
        presenter.setViewDelegate(view: self)
    }
    
    func fetchFriends(){
        presenter.getFriends()
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
    
    func generateRecommendedFriendCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        
        cell.followButton.isHidden = true
        cell.profile = presenter.friends[indexPath.row-1]
        
        return cell
    }
    
}

extension RecommendedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return generateTitleCell(tableView, cellForRowAt: indexPath)
        default:
            return generateRecommendedFriendCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.friends.count+1
    }
}

extension RecommendedViewController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let recommended = UITableViewRowAction(style: .normal, title: "Recomendar") { action, index in
            self.presenter.createRecommendation(friend: self.presenter.friends[index.row-1])
        }
        
        recommended.backgroundColor = UIColor.colorWithHexString("E78A00")
        return [recommended]
    }
}

extension RecommendedViewController: RecommendedDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessage(success: Bool, msg: String) {
        let title = success ? "Success" : "Error"
        present(ViewUtil.alertControllerWithTitle(title: title, withMessage: msg), animated: true, completion: nil)
    }
    
    func dismissRowAction() {
        tableView.setEditing(false, animated: true)
    }
}
