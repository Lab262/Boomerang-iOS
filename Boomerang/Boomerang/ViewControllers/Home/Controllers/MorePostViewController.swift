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
        //tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    func getMorePosts() {
        presenter.getMorePosts()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }

    func registerNib() {
        tableView.registerNibFrom(MorePostTableViewCell.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ThingDetailViewController {
            //controller.presenter.setPost(post: presenter.posts[currentIndex!.row])
        }
    }

}

extension MorePostViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MorePostTableViewCell.identifier, for: indexPath) as! MorePostTableViewCell
        
        cell.presenter.post = presenter.posts[indexPath.row]
        
        cell.setupCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.posts.count
    }
}

extension MorePostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return MorePostTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

extension MorePostViewController: ViewDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showMessageError(msg: String) {
        print ("ERROR MORE POST CONTROLLER: \(msg)")
    }
}


