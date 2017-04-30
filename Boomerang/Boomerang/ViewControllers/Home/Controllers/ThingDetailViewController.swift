//
//  ThingDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class ThingDetailViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationInformationsView: ThingNavigationBar!
    @IBOutlet weak var navigationBarView: IconNavigationBar!
    
    var interestedTitleButton: String? {
        didSet{
            firstButton.setTitle(interestedTitleButton, for: .normal)
        }
    }
    
    let tableViewTopInset: CGFloat = 156.0
    var presenter = DetailThingPresenter()
    var textFieldHeight: CGFloat = 60
    var composeBarView: PHFComposeBarView?
    var container: UIView?
    var keyboardFrameSize: CGRect?
    var initialViewFrame: CGRect?
    var currentCommentsCount = 0
    
    var inputFieldsCondition = [(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: "Posso trocar/emprestar", descriptionCondition: "Tenho uma mesa de ping pong aqui parada. ou então bora conversar.", constraintIconWidth: 14.0, constraintIconHeight: 15.0), (iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: "Tempo que preciso emprestado", descriptionCondition: "1 semana, mas a gente conversa.", constraintIconWidth: 16.0, constraintIconHeight: 16.0), (iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: "Local de retirada", descriptionCondition: "Qualquer lugar em Brasília.", constraintIconWidth: 15.0, constraintIconHeight: 18.0)]
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    func updateComments(){
        presenter.updateComments()
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
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenterDelegate()
        registerNibs()
        configureButtons()
        configureTableView()
        setNavigationInformations()
    }
    
    func setPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureButtons(){
        if !presenter.authorPostIsCurrent() {
            presenter.alreadyInterested()
            secondButton.isHidden = false
            secondButton.setTitle(presenter.getRecommendedTitleButton(), for: .normal)
        } else {
            secondButton.isHidden = true
            firstButton.setTitle(presenter.getInterestedListTitleButton(), for: .normal)
        }
    }
    
    func setNavigationInformations(){
        navigationInformationsView.titleTransactionLabel.text = presenter.getCurrentType()
        navigationInformationsView.thingNameLabel.text = presenter.getPost().title
    }
    
    @IBAction func firstButtonAction(_ sender: Any) {
        if presenter.authorPostIsCurrent() {
            performSegue(withIdentifier: SegueIdentifiers.detailThingToInterestedList, sender: self)
        } else {
            if self.firstButton.currentTitle == presenter.getEnterInterestedTitleButton() {
                presenter.enterInterestedList()
            } else {
                presenter.enterInterestedList()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? InterestedListViewController {
            controller.presenter.setPost(post: presenter.getPost())
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            controller.presenter.setPost(post: presenter.getPost())
        }
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.white
        return viewIndicator
    }
    
    func generatePhotoThingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoThingTableViewCell.identifier, for: indexPath) as! PhotoThingTableViewCell
        
        cell.presenter.setPost(post: presenter.getPost())
        if cell.presenter.getPost().relations == nil {
            cell.presenter.getCountPhotos(success: false)
            cell.presenter.getRelationsImages(success: false)
        } else {
            cell.presenter.downloadImagesPost(success: true)
        }
        
        
        return cell
    }
    
    func generateUserInformationsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInformationTableViewCell.identifier, for: indexPath) as! UserInformationTableViewCell
        
        cell.presenter.setPost(post: presenter.getPost())
        cell.updateCellUI()
        
        return cell
    }
    
    func generateUserDescriptionCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
        
        cell.presenter.setPost(post: presenter.getPost())
        cell.updateCell()
        
        return cell
    }
    
    func generateConditionCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ThingConditionTableViewCell.identifier, for: indexPath) as! ThingConditionTableViewCell
        
        cell.cellData = inputFieldsCondition[indexPath.row-3]
        
        return cell
    }
    
    func generateUserCommentCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCommentTableViewCell.identifier, for: indexPath) as! UserCommentTableViewCell
        
        cell.comment = presenter.getComments()[indexPath.row-inputFieldsCondition.count-4]
        
        return cell
    }
    
    
    func generateTextFieldCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldGroupTableViewCell.identifier, for: indexPath) as! TextFieldGroupTableViewCell
        
        
        return cell
    }
}

extension ThingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case inputFieldsCondition.count+3:
            return textFieldHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: SegueIdentifiers.detailThingToProfile, sender: self)
        default:
            break
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
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
            
            updateComments()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.endEditing(true)
    }
    
     //presenter.createComment(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
}

extension ThingDetailViewController: DetailThingDelegate {
    func reload() {
        if presenter.getComments().count != presenter.getCurrentCommentsCount() {
            tableView.reloadData()
        }
        tableView.tableFooterView?.unload()
    }
    
    func showMessage(isSuccess: Bool, msg: String) {
        let title = isSuccess ? "Certo" : "Erro"
        present(ViewUtil.alertControllerWithTitle(title: title, withMessage: msg), animated: true, completion: nil)
    }
}
