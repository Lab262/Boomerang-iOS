//
//  MorePostViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class MorePostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter = MorePostPresenter()
    var selectedProfile = 0
    let tableViewTopInset: CGFloat = 94.0
    let tableViewBottomInset: CGFloat = 40.0
    
    @IBOutlet weak var navigationBar: IconNavigationBar!
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupViewDelegate()
        getMorePosts()
        configureTableView()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationBar.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, tableViewBottomInset, 0)
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }
    
    func getMorePosts(){
        presenter.getMorePosts()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }

    func registerNib() {
        tableView.registerNibFrom(MorePostTableViewCell.self)
    }
    
    func goToProfile(_ sender: UIButton) {
        selectedProfile = sender.tag
        self.performSegue(withIdentifier: SegueIdentifiers.morePostToProfile, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ThingDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.presenter.post = presenter.posts[indexPath.row]
            }
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            controller.presenter.setProfile(profile: presenter.posts[selectedProfile].author!)
        }
    }

}

extension MorePostViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MorePostTableViewCell.identifier, for: indexPath) as! MorePostTableViewCell
        
        
        cell.coverImage.image = nil
        cell.userImage.image = nil
        cell.presenter.post = presenter.posts[indexPath.row]
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
        
        cell.setupCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.posts.count
    }
}

extension MorePostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.morePostToDetailThing, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MorePostTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

extension MorePostViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            presenter.getMorePosts()
        }
    }
}

extension MorePostViewController: MorePostDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessage(isSuccess: Bool, msg: String) {
        
    }
    
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func startFooterLoading() {
        tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
    }
    
    func finishFooterLoading() {
        self.tableView.tableFooterView?.unload()
    }
}


