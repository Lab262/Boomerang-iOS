//
//  SearchFriendsViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        registerNib()
    }
    
    func configureSearchBar() {
        searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
    }
    
    func registerNib(){
        tableView.registerNibFrom(SearchFriendsTableViewCell.self)
    }

}

extension SearchFriendsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        
        if indexPath.row == 1 {
            cell.backgroundSupportView.isHidden = true
        } else {
            cell.backgroundSupportView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
}

extension SearchFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return SearchFriendsTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

