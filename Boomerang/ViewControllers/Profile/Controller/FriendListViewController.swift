//
//  FriendListViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 11/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationBar: IconNavigationBar!
    
    var presenter = FriendListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNib()
        setupViewDelegate()
        getProfiles()
        self.hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = refreshIndicatorInTableViewFooter()
        setNavigationInformations()
    }
    
    func getProfiles() {
        presenter.getProfiles()
    }
    
//    func popToRoot(_ notification : Notification){
//        navigationController?.popToRootViewController(animated: true)
//    }
    
    func setNavigationInformations(){
        navigationBar.titleLabel.text = presenter.getTitleView()
        navigationBar.titleLabel.setDynamicFont()
        navigationBar.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func registerNib(){
        tableView.registerNibFrom(SearchFriendsTableViewCell.self)
    }

    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }
    
    func generateSearchFriendCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        cell.presenter.profile = presenter.profiles[indexPath.row]
        cell.setupCellInformations(fetchAlreadyFollowing: presenter.isFetchAlreadyFollowing(), isFollowing: !presenter.isFollowers)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ProfileMainViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.presenter.setProfile(profile: presenter.profiles[indexPath.row])
            }
        }
    }
}

extension FriendListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            presenter.getProfiles()
        }
    }
}

extension FriendListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return generateSearchFriendCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.profiles.count
    }
}

extension FriendListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.friendsListToProfile, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return SearchFriendsTableViewCell.cellHeight
    }
}

extension FriendListViewController: FriendListDelegate {
    
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

extension FriendListViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchFriendsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

