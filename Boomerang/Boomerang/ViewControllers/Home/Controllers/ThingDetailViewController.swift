//
//  ThingDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseLiveQuery
import Parse

struct Fields {
    let iconCondition: UIImage
    let titleCondition: String
    let descriptionCondition: String
    let constraintIconWidth: CGFloat
    let constraintIconHeight: CGFloat
}

class ThingDetailViewController: UIViewController {
    
    @IBOutlet weak var buttonsStackView: UIStackView!
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
    
    var inputFieldsCondition: [Fields] = []
    
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
    
    
//    fileprivate func printMessage(_ comment: Comment) {
//        let createdAt = comment.createdAt ?? Date()
//        
//        
//       print("\(comment.content)")
//        
//        
//    }


    func registerNibs(){
        tableView.registerNibFrom(PhotoThingTableViewCell.self)
        tableView.registerNibFrom(UserInformationTableViewCell.self)
        tableView.registerNibFrom(DescriptionTableViewCell.self)
        tableView.registerNibFrom(ThingConditionTableViewCell.self)
        tableView.registerNibFrom(TextFieldGroupTableViewCell.self)
        tableView.registerNibFrom(UserCommentTableViewCell.self)
    }
    
    func configureTableView(){
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, buttonsStackView.frame.height, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInformations()
        setPresenterDelegate()
        registerNibs()
        configureButtons()
        configureTableView()
        setNavigationInformations()
        initializeComposeBar()
        setupKeyboardNotifications()
        getCommentsCount()
        registerObservers()
        setupSubscribe()
    }
    
    func setupInformations(){
        switch presenter.getCurrentType() {
        case TypePostTitles.have:
            setInformationsHave()
        case TypePostTitles.need:
            setInformationsNeed()
        case TypePostTitles.donate:
            setInformationsDonate()
        default:break
        }
    }
    
    func setInformationsHave(){
        setFieldExchange(title: DetailPostTitles.titleHaveChangeOrLoan)
        setFieldTime()
        setFieldPlace()
    }
    
    func setInformationsNeed(){
        setFieldExchange(title: DetailPostTitles.titleNeedChangeOrLoan)
        setFieldTime()
        setFieldPlace()
    }
    
    func setInformationsDonate(){
        setFieldPlace()
    }
    
    func setFieldExchange(title:String){
        let fieldExchange = Fields.init(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: title, descriptionCondition: presenter.post.exchangeDescription!, constraintIconWidth: 14.0*UIView.heightScaleProportion(), constraintIconHeight: 15.0*UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldExchange)
    }
    
    func setFieldTime(){
        let fieldTime = Fields.init(iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: DetailPostTitles.titleTime, descriptionCondition: presenter.post.loanTime!, constraintIconWidth: 16.0*UIView.heightScaleProportion(), constraintIconHeight: 16.0*UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldTime)
    }
    
    func setFieldPlace(){
        let fieldPlace = Fields.init(iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: DetailPostTitles.titlePlace, descriptionCondition: presenter.post.place!, constraintIconWidth: 15.0*UIView.heightScaleProportion(), constraintIconHeight: 18.0*UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldPlace)
    }
    
    func setupSubscribe() {
        presenter.subscribeToUpdateComment()
    }
    
    func getCommentsCount() {
        presenter.getCommentCounts()
        updateComments()
    }
    
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot(_:)), name: NSNotification.Name(rawValue: NotificationKeys.popToRootHome), object: nil)
    }
    
    func popToRoot(_ notification : Notification){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureButtons(){
        
        if !presenter.post.isAvailable {
            firstButton.isHidden = true
            secondButton.isHidden = true
        } else if !presenter.authorPostIsCurrent(){
            presenter.alreadyInterested()
            secondButton.isHidden = false
            secondButton.setTitle(presenter.recommendedTitleButton, for: .normal)
        } else {
            secondButton.isHidden = true
            firstButton.backgroundColor = UIColor.colorWithHexString("FBBB47")
            firstButton.setTitle(presenter.interestedListTitleButton, for: .normal)
        }
    }
    
    func initializeComposeBar(){
        initialViewFrame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 100.0)
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
       navigationBarView.titleBarLabel.text = presenter.getCurrentType()
       navigationInformationsView.thingNameLabel.text = presenter.post.title
       navigationBarView.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
    }
    
    @IBAction func firstButtonAction(_ sender: Any) {
        if presenter.authorPostIsCurrent() {
            performSegue(withIdentifier: SegueIdentifiers.detailThingToInterestedList, sender: self)
        } else {
            if self.firstButton.currentTitle == presenter.enterInterestedTitleButton {
                presenter.enterInterestedList()
            } else {
                presenter.exitInterestedList()
            }
        }
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.detailThingToRecommended, sender: self)
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
            controller.presenter.setPost(post: presenter.post)
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            controller.presenter.setPost(post: presenter.post)
        }
        
        if let controller = segue.destination as? RecommendedViewController {
            controller.presenter.post = presenter.post
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
    
        let commentsMissing = presenter.commentCount
        cell.moreButton.setTitle("Mais \(commentsMissing.description) comentários", for: .normal)
        cell.moreButton.isEnabled = true
        
        if commentsMissing <= 0 {
            commentCount = commentsMissing
        }
        
        return cell
    }
    
    func generatePhotoThingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoThingTableViewCell.identifier, for: indexPath) as! PhotoThingTableViewCell
        
        cell.presenter.post = presenter.post
        
        if cell.presenter.post!.relations == nil {
            cell.presenter.getCountPhotos(success: false)
            cell.presenter.getRelationsImages(success: false)
        } else {
            cell.presenter.downloadImagesPost(success: true)
        }
        
        return cell
    }
    
    func generateUserInformationsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInformationTableViewCell.identifier, for: indexPath) as! UserInformationTableViewCell
        cell.presenter.post = presenter.post
        cell.updateCellUI()
        
        return cell
    }
    
    func generateUserDescriptionCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
        cell.presenter.post = presenter.post
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
            index = (presenter.comments.count-1)-(indexPath.row-inputFieldsCondition.count-5)
        } else {
            index = (presenter.comments.count-1)-(indexPath.row-inputFieldsCondition.count-4)
        }
        
        cell.comment = presenter.comments[index!]
        
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
        
        let rows = inputFieldsCondition.count + 4 + presenter.comments.count
        let rowsWithMoreButton = inputFieldsCondition.count + 5 + presenter.comments.count
        
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
    func startLoading() {
        self.view.loadAnimation()
    }

    func finishLoading() {
        self.view.unload()
    }
    
    func reload() {
        if presenter.comments.count != presenter.currentCommentsCount {
            tableView.reloadData()
        }
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




