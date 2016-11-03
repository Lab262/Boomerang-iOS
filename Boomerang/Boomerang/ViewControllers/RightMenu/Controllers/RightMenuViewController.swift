//
//  RightMenuViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {

    @IBOutlet var coverBackgroundView: UIView!
    @IBOutlet weak var containerRightMenuTableController: UIView!
    
    var menuController: RightMenuTableViewController!
    var currentMainController: UIViewController!
    @IBOutlet weak var constraintMenuTrailingSpace: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performShowMenuAnimation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let currentMenuController = segue.destination as? RightMenuTableViewController {
            
            currentMenuController.mainViewController = currentMainController
            self.menuController = currentMenuController
        }
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        
        self.perfomDismissMenuAnimation()
    }
    
    func performShowMenuAnimation() {
        self.coverBackgroundView.alpha = 0.0
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.coverBackgroundView.alpha = 1.0
        }, completion: { (finished :Bool) -> Void in
       
            if finished {
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
                    
                    self.constraintMenuTrailingSpace.constant = -20
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        })
    }
    
    func perfomDismissMenuAnimation() {
        
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
                self.constraintMenuTrailingSpace.constant = -110
                self.view.layoutIfNeeded()
            }, completion: { (finished :Bool) -> Void in
                
                if finished {
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.coverBackgroundView.alpha = 0.0
                    }, completion: { (finished :Bool) -> Void in
                        
                        if finished {
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })

    }
    
    static func showMenu(inParent viewController: UIViewController) {
        let storyBoardToShow = UIStoryboard(name: "RightMenu", bundle: nil)
        let rightMenuController = storyBoardToShow.instantiateInitialViewController() as! RightMenuViewController
        rightMenuController.currentMainController = viewController
        viewController.present(rightMenuController, animated: true, completion: nil)
    }
}
