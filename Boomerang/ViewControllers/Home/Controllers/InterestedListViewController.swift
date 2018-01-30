//
//  InterestedListViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class InterestedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: InterestedPresenter = InterestedPresenter()
    let tableViewTopInset: CGFloat = 94.0*UIView.heightScaleProportion()
    let tableViewBottomInset: CGFloat = 40.0*UIView.heightScaleProportion()
    
    @IBOutlet weak var navigationBar: IconNavigationBar!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thingNavigationBarHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, tableViewBottomInset, 0)
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    func configureNavigationBar() {
        navigationBar.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
        //iPhone X
        if UIScreen.main.bounds.height >= 812.0 {
            navigationBarHeightConstraint.constant += 25.0
            thingNavigationBarHeightConstraint.constant += 25.0
        }
        
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerNib(){
        tableView.registerNibFrom(InterestedTableViewCell.self)
    }
    
    func setupPresenterDelegate(){
        presenter.setViewDelegate(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
        configureNavigationBar()
        updateInteresteds()
        setupPresenterDelegate()
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }
    
    func updateInteresteds(){
        presenter.updateInteresteds()
    }
    
    func createScheme(_ sender: UIButton) {
        let interestedUser = self.presenter.getInteresteds()[sender.tag]
        let nameInterested = interestedUser.user?.firstName
        
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: "Deseja fechar o esquema com \(nameInterested ?? "")?", positiveAction: "Bora", negativeAction: "Não, bora") { (isPositive) in
            if isPositive {
                self.presenter.setInterested(interested: interestedUser)
                self.presenter.createScheme()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessagesChatViewController {
            controller.profile = presenter.getInterested().user
            controller.chat = presenter.getChat()
        }
    }
}

extension InterestedListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InterestedTableViewCell.identifier, for: indexPath) as! InterestedTableViewCell
        
        cell.presenter.setInterested(interested: presenter.getInteresteds()[indexPath.row])
        cell.initializeSchemeButton.tag = indexPath.row
        cell.initializeSchemeButton.addTarget(self, action: #selector(createScheme(_:)), for: .touchUpInside)
        cell.loadViewCell()
        cell.countLabel.text = "\(indexPath.row+1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getInteresteds().count
    }
}

extension InterestedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.setInterested(interested: presenter.getInteresteds()[indexPath.row])
        presenter.fetchChat()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return InterestedTableViewCell.cellHeight
    }
}

extension InterestedListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
            
            updateInteresteds()
        }
    }
}

extension InterestedListViewController: InterestedDelegate {
    
    func reload() {
        if presenter.getInteresteds().count != presenter.getCurrentInterestedsCount() {
            tableView.reloadData()
        }
        tableView.tableFooterView?.unload()
    }
    
    func showMessage(msg: String) {
        self.view.unload()
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: msg, negativeAction: "Ok") { (isPositive) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func startingLoadingView() {
        view.loadAnimation()
    }
    
    func finishLoadingView() {
        view.unload()
    }
    
    func pushForChatView() {
        performSegue(withIdentifier: SegueIdentifiers.interestedToChat, sender: self)
    }
    
    func presentTo(storyBoard: String, identifier: String) {
        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
    }
}



