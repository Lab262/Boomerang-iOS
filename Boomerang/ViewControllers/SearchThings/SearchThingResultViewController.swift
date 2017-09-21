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
    
    @IBOutlet weak var emptyView: EmptyView!
    var presenter = SearchThingsPresenter()
    var notificationKey: String!
    let tableViewTopInset: CGFloat = 94.0
    let tableViewBottomInset: CGFloat = 40.0

    override func viewDidLoad() {
        super.viewDidLoad()
        registerObservers()
        presenter.setViewDelegate(view: self)
        configureTableView()
        self.emptyView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
        self.getMorePosts()
    
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

    func getMorePosts(){
        presenter.getMorePosts()
    }


    func registerNib(){
        tableView.registerNibFrom(TransactionTableViewCell.self)
    }
    
    func registerObservers(){
//         NotificationCenter.default.addObserver(self, selector: #selector(updateSchemes(_:)), name: NSNotification.Name(rawValue: notificationKey), object: nil)
    }
    
//    func updateSchemes (_ notification: Notification) {
//        if let schemes = notification.object as! [Scheme]? {
//            presenter.setSchemes(schemes: schemes)
//            reload()
//            if presenter.getSchemesFor(postCondition: .loan).count == 0{
//                self.tableView.isHidden = true
//                self.emptyView.isHidden = false
//            }else{
//                self.tableView.isHidden = false
//                self.emptyView.isHidden = true
//            }
//        }
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as? TransactionDetailViewController {
//            
//            destinationVC.presenter.scheme = presenter.getSchemes()[tableView.indexPathForSelectedRow!.row]
//        }
//    }
}

extension SearchThingResultViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
//        cell.presenter.scheme = presenter.getSchemesFor(postCondition: .loan)[indexPath.row]

            //presenter.getSchemes()[indexPath.row]
        cell.updateCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.posts.count
    }
}

extension SearchThingResultViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            presenter.getMorePosts()
        }
    }
}


extension SearchThingResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: SegueIdentifiers.transactionToProfile, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return TransactionTableViewCell.cellHeight*UIView.heightScaleProportion()
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
}

