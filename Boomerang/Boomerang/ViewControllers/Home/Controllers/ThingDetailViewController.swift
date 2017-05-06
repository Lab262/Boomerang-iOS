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
    
    @IBOutlet weak var navigationBarView: ThingBar!
    
    var commentCount: Int? = 0 {
        didSet{
            tableView.reloadData()
        }
    }
    
    var interestedTitleButton: String? {
        didSet{
            firstButton.setTitle(interestedTitleButton, for: .normal)
        }
    }
    
    let tableViewTopInset: CGFloat = 98.0
    var presenter = DetailThingPresenter()
    var textFieldHeight: CGFloat = 60
    var composeBarView: PHFComposeBarView?
    var initialViewFrame: CGRect?
    var container: UIView?
    var keyboardFrameSize: CGRect?
    var currentCommentsCount = 0
    
    var inputFieldsCondition = [(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: "Posso trocar/emprestar", descriptionCondition: "Tenho uma mesa de ping pong aqui parada. ou então bora conversar.", constraintIconWidth: 14.0, constraintIconHeight: 15.0), (iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: "Tempo que preciso emprestado", descriptionCondition: "1 semana, mas a gente conversa.", constraintIconWidth: 16.0, constraintIconHeight: 16.0), (iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: "Local de retirada", descriptionCondition: "Qualquer lugar em Brasília.", constraintIconWidth: 15.0, constraintIconHeight: 18.0)]
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    func updateComments(_ sender: UIButton? = nil){
        sender?.isEnabled = false
        presenter.getLastsComments()
    }
    
    func initializeContainer() {
        container = UIView(frame: initialViewFrame!)
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        //tableView.tableFooterView = refreshIndicatorInTableViewFooter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenterDelegate()
        registerNibs()
        configureButtons()
        configureTableView()
        setNavigationInformations()
        navigationBarView.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
        initialViewFrame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 100.0)
        initializeComposeBar()
        setupKeyboardNotifications()
        presenter.getCommentCounts()
        updateComments()
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    func initializeComposeBar(){
        composeBarView = PHFComposeBarView(frame: CGRect(x: 0.0, y: (initialViewFrame?.size.height)! - PHFComposeBarViewInitialHeight, width: (initialViewFrame?.size.width)!, height: PHFComposeBarViewInitialHeight))
        composeBarView?.maxCharCount = 160
        composeBarView?.maxLinesCount = 5
        composeBarView?.placeholder = "Comente"
        composeBarView?.textView.accessibilityIdentifier = "Input"
        composeBarView?.placeholderLabel.accessibilityIdentifier = "Placeholder"
        composeBarView?.delegate = self
        composeBarView?.buttonTitle = "Enviar"
        composeBarView?.utilityButton.accessibilityIdentifier = "Utility"
        container = UIView(frame: initialViewFrame!)
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container?.addSubview(composeBarView!)
        
        self.view.addSubview(container!)
    }

    
    func setNavigationInformations(){
       // navigationInformationsView.titleTransactionLabel.text = presenter.getCurrentType()
       // navigationInformationsView.thingNameLabel.text = presenter.getPost().title
    }
    
    @IBAction func firstButtonAction(_ sender: Any) {
        if presenter.authorPostIsCurrent() {
            performSegue(withIdentifier: SegueIdentifiers.detailThingToInterestedList, sender: self)
        } else {
            if self.firstButton.currentTitle == presenter.getEnterInterestedTitleButton() {
                presenter.enterInterestedList()
            } else {
                presenter.exitInterestedList()
            }
        }
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.configureGestureRecognizer()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let  obj = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] {
            var keyboardFrame = CGRect.null
            if (obj as AnyObject).responds(to: #selector(NSValue.getValue(_:))) {
                (obj as AnyObject).getValue(&keyboardFrame)
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0.0,
                    options: UIViewAnimationOptions(),
                    animations: {
                        () -> Void in
                        //self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height+10, 0.0)
                        self.firstButton.alpha = 0.0
                        if !self.secondButton.isHidden {
                            self.secondButton.alpha = 0.0
                        }
                        self.view.frame.origin.y = -keyboardFrame.size.height
                        self.container?.frame.origin.y = (self.container?.frame.origin.y)! - 100
                        
                },
                    completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                () -> Void in
                // self.tableView.contentInset = UIEdgeInsets.zero
                self.firstButton.alpha = 1.0
                if !self.secondButton.isHidden {
                    self.secondButton.alpha = 1.0
                }
                
                self.view.frame.origin.y = 0
                self.container?.frame.origin.y = (self.container?.frame.origin.y)! + 100
        },
            completion: nil)
    }
    
    func configureGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        tableView.addGestureRecognizer(panGesture)
    }
    
    func didPan(_ gesture : UIGestureRecognizer) {
        tableView.endEditing(true)
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
    
    func generateMoreButton(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreCommentTableViewCell.identifier, for: indexPath) as! MoreCommentTableViewCell
        
        cell.moreButton.addTarget(self, action: #selector(updateComments(_:)), for: .touchUpInside)
    
        let commentsMissing = commentCount! - presenter.getComments().count
        cell.moreButton.setTitle("Mais \(commentsMissing.description) comentários", for: .normal)
        cell.moreButton.isEnabled = true
        
        if commentsMissing <= 0 {
            commentCount = commentsMissing
        }
        return cell
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
        
        var index: Int?
        
        if commentCount! > 0 {
            index = (presenter.getComments().count-1)-(indexPath.row-inputFieldsCondition.count-5)
        } else {
            index = (presenter.getComments().count-1)-(indexPath.row-inputFieldsCondition.count-4)
        }
        
        cell.comment = presenter.getComments()[index!]
        
        return cell
    }
    
    
    func generateTextFieldCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldGroupTableViewCell.identifier, for: indexPath) as! TextFieldGroupTableViewCell
        
        cell.commentButton.addTarget(self, action: #selector(textFieldFirstResponder(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func textFieldFirstResponder(_ sender: UIButton) {
        composeBarView?.becomeFirstResponder()
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
            tableView.deselectRow(at: indexPath, animated: true)
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
        case inputFieldsCondition.count+4:
            if commentCount! > 0 {
                return generateMoreButton(tableView, cellForRowAt: indexPath)
            } else {
                return generateUserCommentCell(tableView, cellForRowAt: indexPath)
            }
        default:
            return generateUserCommentCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = inputFieldsCondition.count + 4 + presenter.getComments().count
        let rowsWithMoreButton = inputFieldsCondition.count + 5 + presenter.getComments().count
        
        if commentCount! > 0 {
            return rowsWithMoreButton
        } else {
            return rows
        }
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
//        
//        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
//            tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
//            
//            updateComments()
//        }
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
        composeBarView?.resignFirstResponder()
        
        
        
    }
}

extension ThingDetailViewController: DetailThingDelegate {
    
    func reload() {
        if presenter.getComments().count != presenter.getCurrentCommentsCount() {
            tableView.reloadData()
            
        }
        //tableView.tableFooterView?.unload()
    }
    
    func showMessage(isSuccess: Bool, msg: String) {
        let title = isSuccess ? "Certo" : "Erro"
        present(ViewUtil.alertControllerWithTitle(title: title, withMessage: msg), animated: true, completion: nil)
    }
}

extension ThingDetailViewController: PHFComposeBarViewDelegate {
    
    func composeBarViewDidPressButton(_ composeBarView: PHFComposeBarView!) {
        if composeBarView.text != "" {
            presenter.createComment(text: composeBarView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        composeBarView.setText("", animated: true)
        composeBarView.resignFirstResponder()
    }
    
    func composeBarView(_ composeBarView: PHFComposeBarView!, willChangeFromFrame startFrame: CGRect, toFrame endFrame: CGRect, duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
    }
}

//MARK: UIGestureRecognizer Protocol
extension ThingDetailViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

