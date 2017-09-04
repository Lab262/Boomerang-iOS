//
//  RecommendedViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 15/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import SwipeCellKit

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
        (cell as SwipeTableViewCell).delegate = self

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
            return SearchFriendsTableViewCell.cellHeight 
        }
    }
    
}

extension RecommendedViewController: RecommendedDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessage(success: Bool, msg: String) {

        if !success {
            GenericBoomerAlertController.presentMe(inParent: self, withTitle: msg, negativeAction: "Ok") { (isPositive) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func dismissRowAction() {
        tableView.setEditing(false, animated: true)
    }
}

extension RecommendedViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .left else { return nil }

        let throwAction = SwipeAction(style: .default, title: nil ) { action, indexPath in
            let searchFriendsCell = tableView.cellForRow(at: indexPath) as! SearchFriendsTableViewCell
            searchFriendsCell.toggleRecomendedAnimation()
                        self.presenter.createRecommendation(friend: self.presenter.friends[indexPath.row-1])

        }
        throwAction.image = #imageLiteral(resourceName: "throwActionBackground")
        throwAction.backgroundColor = .white
        return [throwAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        options.buttonSpacing = 0
        options.buttonPadding = -5.0
        options.backgroundColor = .white

        return options
    }
}
