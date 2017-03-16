//
//  ThingDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThingDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var thingImage: UIImageView!
    
    @IBOutlet weak var thingHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var navigationBarView: IconNavigationBar!
    
    let thingImageViewHeight: CGFloat = 209.0
    let tableViewTopInset: CGFloat = 156.0
    let bottomMargin: CGFloat = 10.0
    
    func registerNibs(){
        self.tableView.register(UINib(nibName: "RecommendedPost", bundle: nil), forCellReuseIdentifier: ThingInformationTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, bottomMargin, 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateInformationThingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ThingInformationTableViewCell.identifier, for: indexPath) as! ThingInformationTableViewCell
        
        cell.actionDelegate = self
        
        return cell
    }
}

extension ThingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return generateInformationThingCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ThingDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254
    }
}


extension ThingDetailViewController: ButtonActionDelegate {
    
    func actionButtonDelegate(actionType: ActionType?) {
        
        switch actionType!{
        case .back:
            _ = self.navigationController?.popViewController(animated: true)
        case .like:
            print ("LIKE THING")
        }
    }
}

extension ThingDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        
        updateImageScale(yOffset)
        updateNavigationBarAlpha(yOffset)
        updateInformationsCell(yOffset)
    }
    
    func updateInformationsCell(_ yOffset: CGFloat) {
        
        let informationAlphaThreshold: CGFloat = 20.0
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        
        if yOffset > 0 {
            
            let alpha = (yOffset)/informationAlphaThreshold
            
            print(alpha)
            print("yofset \(yOffset)")
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(alpha)
            
        } else {
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(0.0)
        }
    }
    
    func updateImageScale(_ yOffset: CGFloat) {
        if yOffset < 0 {
            thingHeightConstraint.constant = thingImageViewHeight - yOffset
        } else if thingHeightConstraint.constant != thingImageViewHeight {
            thingHeightConstraint.constant = thingImageViewHeight
        }
    }
    
    func updateNavigationBarAlpha(_ yOffset: CGFloat) {
        let navbarAlphaThreshold: CGFloat = 64.0
        
        if yOffset > (thingImageViewHeight - navbarAlphaThreshold) {
            
            let alpha = (yOffset - thingImageViewHeight + navbarAlphaThreshold)/navbarAlphaThreshold
            
            navigationBarView.view.backgroundColor = navigationBarView.view.backgroundColor?.withAlphaComponent(alpha)
        } else {
            navigationBarView.view.backgroundColor = navigationBarView.view.backgroundColor?.withAlphaComponent(0.0)
        }
    }
}

