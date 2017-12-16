//
//  LoanTransactionViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchThingResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchPlaceholderLabel: UILabel!
    
    @IBOutlet weak var emptyView: EmptyView!
    var presenter = SearchThingsPresenter()
    var notificationKey: String!
    let tableViewTopInset: CGFloat = 0.0
    let tableViewBottomInset: CGFloat = 40.0
    var selectedProfile = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(view: self)
        configureTableView()
        self.emptyView.isHidden = true
        self.presenter.getMorePosts()
    }

    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }

    func configureTableView(){
        registerNib()
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, tableViewBottomInset, 0)
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }


    func registerNib(){
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

extension SearchThingResultViewController : UITableViewDataSource {
    
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
        if presenter.posts.count > 0 {
            self.searchPlaceholderLabel.isHidden = true
        } else {
            self.searchPlaceholderLabel.isHidden = false
        }
        return presenter.posts.count
    }
}

extension SearchThingResultViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            presenter.getMorePosts()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissKeyboard"), object: nil)
    }
}


extension SearchThingResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.morePostToDetailThing, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MorePostTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

extension SearchThingResultViewController: SearchThingsResultDelegate {
    
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

    func didSearch(scope: TypePostEnum, searchString: String) {
       self.presenter.searchPost(in: scope, with: searchString)
    }
}

