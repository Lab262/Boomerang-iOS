//
//  ThingDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol UpdateInformationsDelegate {
    func updateCellBy(height: CGFloat)
    func sendTextByField(text: String)
}

class ThingDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationInformationsView: ThingNavigationBar!
    @IBOutlet weak var navigationBarView: IconNavigationBar!
    
    let tableViewTopInset: CGFloat = 156.0
    var presenter = DetailThingPresenter()
    var textFieldHeight: CGFloat = 60
    var composeBarView: PHFComposeBarView?
    var container: UIView?
    var keyboardFrameSize: CGRect?
    var initialViewFrame: CGRect?
    
    
    var inputFieldsCondition = [(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: "Posso trocar/emprestar", descriptionCondition: "Tenho uma mesa de ping pong aqui parada. ou então bora conversar.", constraintIconWidth: 14.0, constraintIconHeight: 15.0), (iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: "Tempo que preciso emprestado", descriptionCondition: "1 semana, mas a gente conversa.", constraintIconWidth: 16.0, constraintIconHeight: 16.0), (iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: "Local de retirada", descriptionCondition: "Qualquer lugar em Brasília.", constraintIconWidth: 15.0, constraintIconHeight: 18.0)]
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.removeTabBar()
        presenter.updateComments()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TabBarController.mainTabBarController.showTabBar()
        
    }

    func registerNibs(){
        tableView.registerNibFrom(PhotoThingTableViewCell.self)
        tableView.registerNibFrom(UserInformationTableViewCell.self)
        tableView.registerNibFrom(DescriptionTableViewCell.self)
        tableView.registerNibFrom(ThingConditionTableViewCell.self)
        tableView.registerNibFrom(TextFieldGroupTableViewCell.self)
        tableView.registerNibFrom(UserCommentTableViewCell.self)
    }
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setControllerDelegate(controller: self)
        registerNibs()
        configureTableView()
    }
    
    func generatePhotoThingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoThingTableViewCell.identifier, for: indexPath) as! PhotoThingTableViewCell
        return cell
    }
    
    func generateUserInformationsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInformationTableViewCell.identifier, for: indexPath) as! UserInformationTableViewCell
        
        return cell
    }
    
    func generateUserDescriptionCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
        
        return cell
    }
    
    func generateConditionCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ThingConditionTableViewCell.identifier, for: indexPath) as! ThingConditionTableViewCell
        
        cell.cellData = inputFieldsCondition[indexPath.row-3]
        
        return cell
    }
    
    func generateUserCommentCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCommentTableViewCell.identifier, for: indexPath) as! UserCommentTableViewCell
        
        cell.comment = presenter.getComments()[indexPath.row]
        
        return cell
    }
    
    
    func generateTextFieldCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldGroupTableViewCell.identifier, for: indexPath) as! TextFieldGroupTableViewCell
        
        cell.delegate = self
        
        return cell
    }
}

extension ThingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return textFieldHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
}
 extension ThingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return generatePhotoThingCell(tableView, cellForRowAt: indexPath)
        case 1:
            return generateUserInformationsCell(tableView, cellForRowAt: indexPath)
        case 2:
            return generateUserDescriptionCell(tableView, cellForRowAt: indexPath)
        case 3..<inputFieldsCondition.count+3:
            return generateConditionCell(tableView, cellForRowAt: indexPath)
        case inputFieldsCondition.count+3:
            return generateTextFieldCell(tableView, cellForRowAt: indexPath)
        default:
            return generateUserCommentCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFieldsCondition.count + 4 + presenter.getComments().count
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.endEditing(true)
    }
}

extension ThingDetailViewController: UpdateInformationsDelegate {
    
    func updateCellBy(height: CGFloat) {
        print ("HEIGHT UPDATE: \(height)")
        self.textFieldHeight = height+15
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.tableView.setContentOffset(CGPoint(x: self.tableView.contentOffset.x, y: self.tableView.contentOffset.y-20), animated: false)
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            self.tableView.scrollToRow(at: IndexPath.init(row: 3, section: 0) , at: .bottom, animated: false)
            
        }, completion: nil)
    }
    
    func sendTextByField(text: String) {
        presenter.createComment(text: text)
    }
}

extension ThingDetailViewController: ViewControllerDelegate {
    
    func updateView(array: [Any]) {
        tableView.reloadData()
    }
    
    func showMessageError(msg: String) {
        self.present(ViewUtil.alertControllerWithTitle(_title: "Error", _withMessage: msg), animated: true, completion: nil)
    }
}
