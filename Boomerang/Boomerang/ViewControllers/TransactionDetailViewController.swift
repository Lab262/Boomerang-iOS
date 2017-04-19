//
//  TransactionDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    let tableViewTopInset: CGFloat = 131.0
    
    @IBOutlet weak var finalizeButton: UIButton!
    
    var presenter: TransactionDetailPresenter = TransactionDetailPresenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
    }
    
    func registerNib(){
        tableView.registerNibFrom(LinkPostTableViewCell.self)
        tableView.registerNibFrom(TransactionDetailTableViewCell.self)
    }
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segmentVC = segue.destination as? ThingDetailViewController  {
            
            segmentVC.presenter.setPost(post: presenter.getScheme().post!)
        }
    }
    
    func generateLinkPostCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkPostTableViewCell.identifier, for: indexPath) as! LinkPostTableViewCell
        
        cell.showPostButton.addTarget(self, action: #selector(goLinkPost(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func goLinkPost (_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.transactionToDetailThing, sender: self)
    }
    
    func generateTransactionDetailCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailTableViewCell.identifier, for: indexPath) as! TransactionDetailTableViewCell
        
        cell.presenter.setScheme(scheme: presenter.getScheme())
        cell.updateInformationsCell()
        
        return cell
    }
    
    @IBAction func finalizeTransaction(_ sender: Any) {
        
    }
    
    
}

extension TransactionDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            return generateLinkPostCell(tableView, cellForRowAt: indexPath)
        case 1:
            return generateTransactionDetailCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
}

extension TransactionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return LinkPostTableViewCell.cellHeight
        case 1:
            return TransactionDetailTableViewCell.cellHeight
        default:
            return 0
        }
    }
}

extension TransactionDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        updateInformationsCell(yOffset)
    }
    
    func updateInformationsCell(_ yOffset: CGFloat) {
        let informationAlphaThreshold: CGFloat = 20.0
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        if yOffset > 0 {
            let alpha = (yOffset)/informationAlphaThreshold
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(alpha)
        } else {
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(0.0)
        }
    }
}
