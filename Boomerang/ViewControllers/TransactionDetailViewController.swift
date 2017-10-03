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
    
    @IBOutlet weak var navigationBar: ThingBar!
    
    
    @IBOutlet weak var finalizeButton: UIButton!
    
    @IBOutlet weak var thingNavigationBar: ThingNavigationBar!
    
    var presenter: TransactionDetailPresenter = TransactionDetailPresenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
        setupPresenterDelegate()
        setupPopoverAction()
        seePost()
        
        if self.presenter.scheme.statusSchemeEnum == .done || self.presenter.scheme.statusSchemeEnum == .finished || self.presenter.scheme.statusSchemeEnum == .negotiation || self.presenter.userRated() {
            self.finalizeButton.isHidden = true
        }
        configureNavigationsBars()
    }
    
    func seePost() {
        presenter.seeScheme()
    }
    
    func configureNavigationsBars(){
        
        switch presenter.scheme.post!.typePostEnum! {
        case .have:
            navigationBar.titleLabelText = TypePostTitles.have
        case .need:
            navigationBar.titleLabelText = TypePostTitles.need
        case .donate:
            navigationBar.titleLabelText = TypePostTitles.donate
        }

        thingNavigationBar.thingNameLabel.text = presenter.scheme.post?.title
        
        navigationBar.titleBarLabel.setDynamicFont()
        thingNavigationBar.thingNameLabel.setDynamicFont()
    }
    
    func setupPopoverAction(){
        navigationBar.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func registerNib(){
        tableView.registerNibFrom(LinkPostTableViewCell.self)
        tableView.registerNibFrom(TransactionDetailTableViewCell.self)
    }
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? ThingDetailViewController  {
            viewController.presenter.post = presenter.scheme.post!
        }
        
        if let viewController = segue.destination as? ProfileMainViewController  {
            viewController.presenter.setProfile(profile: presenter.getDealerTransaction())
        }
        
        if let viewController = segue.destination as? MessagesChatViewController  {
            viewController.chat = presenter.chat
            viewController.profile = presenter.getDealerTransaction()
        }
    }
    
    func generateLinkPostCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkPostTableViewCell.identifier, for: indexPath) as! LinkPostTableViewCell
        
        cell.datePostLabel.text = ("Post feito em: \(presenter.getCreatedPost().getStringToDate(dateFormat: "dd/MM/YYYY"))")
        
        cell.showPostButton.addTarget(self, action: #selector(goLinkPost(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func goLinkPost (_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.detailTransactionToDetailThing, sender: self)
    }
    
    func goLinkProfile (_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.detailTransactionToProfile, sender: self)
    }
    
    func goChat (_ sender: UIButton) {
        presenter.fetchChat()
    }
    func generateTransactionDetailCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailTableViewCell.identifier, for: indexPath) as! TransactionDetailTableViewCell
        
        cell.profileLinkButton.addTarget(self, action: #selector(goLinkProfile(_:)), for: .touchUpInside)
        cell.chatButton.addTarget(self, action: #selector(goChat(_:)), for: .touchUpInside)
        cell.presenter.scheme = presenter.scheme
        cell.updateInformationsCell()
        
        if self.presenter.scheme.statusSchemeEnum != .done && self.presenter.scheme.statusSchemeEnum != .finished  {
            cell.arrowRoundImage.isHidden = true
            cell.dateFinishLabel.isHidden = true
            cell.finishLabel.isHidden = true
            cell.startLabelCenterLeftConstraint.isActive = false
            cell.startLabelCenterConstraint.isActive = true
            cell.layoutIfNeeded()
        }
        
        cell.cancelButtonContainerView.isHidden = true
        
        return cell
    }
    
    @IBAction func finalizeTransaction(_ sender: Any) {
        self.push(identifier: SegueIdentifiers.detailTransactionToEvaluation)
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

extension TransactionDetailViewController: TransactionDetailDelegate {
    func reload() {
        
    }
    
    func showMessage(msg: String) {
        
    }
    
    func startingLoadingView() {
        self.view.loadAnimation()
    }
    
    func finishLoadingView() {
        self.view.unload()
    }
    
    func push(identifier: String) {
        if identifier == SegueIdentifiers.detailTransactionToEvaluation {
            let viewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Transaction", identifier: "evaluationView") as? EvaluationViewController
            viewController?.presenter.scheme = presenter.scheme
            self.present(viewController!, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: identifier, sender: self)
        }
        
    }
    
}
