//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse

protocol ViewDelegate {
    func showMessageError(msg: String)
    func reload()
}

class HomeMainViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var boomerThingDelegate: UICollectionViewDelegate?
    var currentIndex: IndexPath?
    let tableViewTopInset: CGFloat = 0
    let tableViewBottomInset: CGFloat = 40.0
    var presenter = HomePresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TabBarController.mainTabBarController.showTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDelegate()
        setupNavigationConfiguration()
        setupUserInformationsInHUD()
        setupNavigationConfiguration()
        setupTableViewConfiguration()
        registerNib()
        registerObservers()
        getTimeLinePosts()
        setupSubscribe()
    }
    
    @IBAction func showSearchThingsVC(_ sender: Any) {
        TabBarController.mainTabBarController.hideTabBar()
        let viewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("SearchThings")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    func setupSubscribe() {
        presenter.setupSubscribes()
    }
    
    func getTimeLinePosts() {
        presenter.getTimeLinePosts()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
    func popToRoot(_ notification : Notification){
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ThingDetailViewController {
            switch presenter.currentSectionPost! {
            case .recommended:
                controller.presenter.post = presenter.featuredPosts[currentIndex!.row]
            case .friends:
                controller.presenter.post = presenter.friendsPosts[currentIndex!.row]
            case .city:
                controller.presenter.post = presenter.othersPosts[currentIndex!.row]
            }
        }
        
        if let controller = segue.destination as? MorePostViewController {
            switch presenter.currentSectionPost! {
            case .recommended:
                controller.presenter.posts = presenter.featuredPosts
                controller.presenter.sectionPost = presenter.currentSectionPost
            case .friends:
                controller.presenter.posts = presenter.friendsPosts
                controller.presenter.sectionPost = presenter.currentSectionPost
                controller.presenter.friends = presenter.following
            case .city:
                controller.presenter.posts = presenter.othersPosts
                controller.presenter.sectionPost = presenter.currentSectionPost
            }
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            switch presenter.currentSectionPost! {
            case .recommended:
                controller.presenter.setProfile(profile: presenter.featuredPosts[currentIndex!.row].author!)
            case .friends:
                controller.presenter.setProfile(profile: presenter.friendsPosts[currentIndex!.row].author!)
            case .city:
                controller.presenter.setProfile(profile: presenter.othersPosts[currentIndex!.row].author!)
            }
        }
    }
}

extension HomeMainViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return generateRecommendedCell(tableView, cellForRowAt: indexPath)
        case 1:
            return generateFriendsPostsCell(tableView, cellForRowAt: indexPath)
        default:
            return generateOthersPostsCell(tableView, cellForRowAt: indexPath)
        }
    }
}

extension HomeMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = generateHeaderTitle(tableView, viewForHeaderInSection: section)

        switch section {
        case 1:
            header?.titleLabel.text = HomeHeaderTitles.myFriends
        case 2:
            header?.titleLabel.text = HomeHeaderTitles.myCity
        default:
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 350 * UIView.heightScaleProportion()
        default:
            return 250 * UIView.heightScaleProportion()
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 1, 2:
            return HeaderPostTableViewCell.cellHeight
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}


extension HomeMainViewController {
    
    func setupUserInformationsInHUD(){
        greetingText.text = HomeHeaderTitles.greeting + presenter.profile.firstName!
        profileImage.getUserImageFrom(file: presenter.profile.photo!) { (success, msg) in
        }
    }
    
    func setupViewDelegate() {
        presenter.setControllerDelegate(delegate: self)
    }
    
    func setupNavigationConfiguration() {
        navigationController?.navigationBar.isHidden = true
    }
    

    func setupTableViewConfiguration() {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
    }
    
    func registerNib() {
        tableView.registerNibFrom(HomeCollectionHeader.self)
        tableView.registerNibFrom(RecommendedPostTableViewCell.self)
        tableView.registerNibFrom(PostTableViewCell.self)
    }
    
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot(_:)), name: NSNotification.Name(rawValue: NotificationKeys.popToRootHome), object: nil)
    }
}

extension HomeMainViewController {
    
    func generateHeaderTitle(_ tableView: UITableView, viewForHeaderInSection section: Int) -> HomeCollectionHeader? {
        
        let header = tableView.dequeueReusableCell(withIdentifier:HomeCollectionHeader.identifier) as! HomeCollectionHeader
        
        return header
    }
    
    func generateRecommendedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedPostTableViewCell.identifier, for: indexPath) as! RecommendedPostTableViewCell
        
        cell.presenter.posts = presenter.featuredPosts
        cell.updateCell()
        cell.delegate = self
        cell.selectionDelegate = self
        boomerThingDelegate = cell
        
        return cell
    }
    
    func generateFriendsPostsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        cell.presenter.posts = presenter.friendsPosts
        cell.tag = SectionPost.friends.rawValue
        cell.delegate = self
        cell.selectionDelegate = self
        
        return cell
    }
    
    func generateOthersPostsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        cell.presenter.posts = presenter.othersPosts
        cell.tag = SectionPost.city.rawValue
        cell.delegate = self
        cell.selectionDelegate = self
        
        return cell
    }

}

extension HomeMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        updateNavigationBarAlpha(yOffset)
        updateInformationsCell(yOffset)
    }
    
    func scrollTableViewToTop() {
        tableView.setContentOffset(CGPoint(x: 0, y: -44), animated: true)
    }
    
    
    func updateNavigationBarAlpha(_ yOffset: CGFloat) {
        let navbarAlphaThreshold: CGFloat = 64.0
        if yOffset > (tableViewTopInset - navbarAlphaThreshold) {
            let alpha = (yOffset - tableViewTopInset + navbarAlphaThreshold)/navbarAlphaThreshold
            navigationBarView.backgroundColor = navigationBarView.backgroundColor?.withAlphaComponent(alpha)
        } else {
            navigationBarView.backgroundColor = navigationBarView.backgroundColor?.withAlphaComponent(0.0)
        }
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

extension HomeMainViewController: ViewDelegate {
    
    func reload(){
        
        tableView.reloadData()
//        
//        if presenter.friendsPosts.count != presenter.currentPostsFriendsCount {
//            tableView.reloadData()
//        }
    }

    func showMessageError(msg: String) {
        //present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
    }
    
}

extension HomeMainViewController: UpdateCellDelegate{
    func unload() {
        
    }
    func updateCell() {
        getTimeLinePosts()
    }
}

extension HomeMainViewController: CollectionViewSelectionDelegate {
    func pushFor(identifier: String, sectionPost: SectionPost?, didSelectItemAt indexPath: IndexPath?) {
        if identifier == SegueIdentifiers.homeToProfile {
            self.currentIndex = indexPath
            presenter.currentSectionPost = sectionPost
            self.performSegue(withIdentifier: identifier, sender: self)
        } else {
            self.currentIndex = indexPath
            presenter.currentSectionPost = sectionPost
            self.performSegue(withIdentifier: identifier, sender: self)
        }

    }
}


