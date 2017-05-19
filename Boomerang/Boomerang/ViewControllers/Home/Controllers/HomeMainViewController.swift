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

    internal var homeTableViewController: HomeTableViewController!
    internal var homeBoomerThingsData = [String: [BoomerThing]]()
    var boomerThingDelegate: UICollectionViewDelegate?
    var currentSectionPost: SectionPost?
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var currentIndex: IndexPath?
    let tableViewTopInset: CGFloat = 0
    let tableViewBottomInset: CGFloat = 40.0
    var presenter = HomePresenter()

    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    @IBAction func showMenu(_ sender: Any) {
        //TabBarController.mainTabBarController.showTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TabBarController.mainTabBarController.showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setControllerDelegate(controller: self)
        presenter.updatePostsFriends()
        self.navigationController?.navigationBar.isHidden = true
        setUserInformationsInHUD()
        self.searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
        
        registerNib()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
        registerObservers()
    }
    
    func registerNib() {
        tableView.registerNibFrom(HomeCollectionHeader.self)
        tableView.registerNibFrom(RecommendedPostTableViewCell.self)
        tableView.registerNibFrom(PostTableViewCell.self)
    }
    
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot(_:)), name: NSNotification.Name(rawValue: NotificationKeys.popToRootHome), object: nil)
    }
    
    func popToRoot(_ notification : Notification){
        navigationController?.popToRootViewController(animated: true)
    }

    
    func loadHomeData(homeBoomerThingsData: [String: [BoomerThing]]) {
        self.homeBoomerThingsData = homeBoomerThingsData
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ThingDetailViewController {
            switch currentSectionPost! {
            case .recommended:
                controller.presenter.setPost(post: presenter.getFeaturedPosts()[currentIndex!.row])
            case .friends:
                controller.presenter.setPost(post: presenter.friendsPosts[currentIndex!.row])
            case .city:
                controller.presenter.setPost(post: presenter.othersPosts[currentIndex!.row])
            }
        }
        
        if let controller = segue.destination as? MorePostViewController {
            switch currentSectionPost! {
            case .recommended:
                controller.presenter.posts = presenter.getFeaturedPosts()
            case .friends:
                controller.presenter.posts = presenter.friendsPosts
            case .city:
                controller.presenter.posts = presenter.othersPosts
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
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = generateHeaderTitle(tableView, viewForHeaderInSection: section)
        
        switch section {
        case 1:
            header?.titleLabel.text = "Meus migos"
        case 2:
            header?.titleLabel.text = "Em Brasília"
        default:
            return nil
            
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 350
        default:
            return 250
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 1, 2:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}


extension HomeMainViewController {
    
    func setUserInformationsInHUD(){
        greetingText.text = "Olar, \(presenter.user.firstName!)"
        self.profileImage.loadAnimation()
        presenter.getUserImage { (success, msg, image) in
            if success {
                self.profileImage.unload()
                self.profileImage.image = image
                self.presenter.user.profileImage = image
            } else {
                self.profileImage.unload()
                self.showMessageError(msg: msg)
            }
        }
    }
}

extension HomeMainViewController {
    
    func generateHeaderTitle(_ tableView: UITableView, viewForHeaderInSection section: Int) -> HomeCollectionHeader? {
        let header = tableView.dequeueReusableCell(withIdentifier:HomeCollectionHeader.identifier) as! HomeCollectionHeader
        
        return header
    }
    
    func generateRecommendedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedPostTableViewCell.identifier, for: indexPath) as! RecommendedPostTableViewCell
        
        cell.presenter.posts = presenter.getFeaturedPosts()
        cell.updateCell()
        cell.delegate = self
        cell.selectionDelegate = self
        boomerThingDelegate = cell
        
        return cell
    }
    
    func generateFriendsPostsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        cell.presenter.posts = presenter.friendsPosts
        cell.reloadCollection()
        cell.tag = SectionPost.friends.rawValue
        cell.delegate = self
        cell.selectionDelegate = self
        
        return cell
    }
    
    func generateOthersPostsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        cell.presenter.posts = presenter.othersPosts
        cell.reloadCollection()
        cell.tag = SectionPost.city.rawValue
        cell.delegate = self
        cell.selectionDelegate = self
        
        return cell
    }
    
    func generateMorePostsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: 250))
        cell.backgroundColor = UIColor.yellowBoomerColor
        cell.textLabel?.text = "VIEW MORE"
        cell.textLabel?.textAlignment = .center
        
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
        if presenter.friendsPosts.count != presenter.currentPostsFriendsCount {
            tableView.reloadData()
        }
    }

    func showMessageError(msg: String) {
        //present(ViewUtil.alertControllerWithTitle(_title: "Erro", _withMessage: msg), animated: true, completion: nil)
    }
    
}

extension HomeMainViewController: UpdateCellDelegate{
    func unload() {
        
    }

    func updateCell() {
        presenter.updatePostsFriends()
    }
}

extension HomeMainViewController: CollectionViewSelectionDelegate {
    
    func collectionViewDelegate(_ colletionViewDelegate: UICollectionViewDelegate, didSelectItemAt indexPath: IndexPath) {
        if colletionViewDelegate === boomerThingDelegate {
            self.currentIndex = indexPath
            self.performSegue(withIdentifier: SegueIdentifiers.homeToDetailThing, sender: self)
        } else {
            
        }
    }
    
    func pushFor(identifier: String, sectionPost: SectionPost, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath
        self.currentSectionPost = sectionPost
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}



