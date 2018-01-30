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
    var currentIndexPath: IndexPath?
    @IBOutlet weak var thingNavigationBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thingBarHeightConstraint: NSLayoutConstraint!
    
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
    
    let authorPostTag = 00
    var tableViewTopInset: CGFloat = 90.0*UIView.heightScaleProportion()
    var presenter = DetailThingPresenter()
    var textFieldHeight: CGFloat = 70
    var composeBarView: PHFComposeBarView?
    var initialViewFrame: CGRect?
    var container: UIView?
    var keyboardFrameSize: CGRect?
    var currentCommentsCount = 0
    var defaultValueAlphaTitleNavigation:CGFloat = 1.0
    
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
        tableView.registerNibFrom(AmountPostInteractionTableViewCell.self)
        tableView.registerNibFrom(DescriptionTableViewCell.self)
        tableView.registerNibFrom(ThingConditionTableViewCell.self)
        tableView.registerNibFrom(ActionsPostTableViewCell.self)
        tableView.registerNibFrom(UserCommentTableViewCell.self)
    }
    
    func configureTableView(){
        
        //Set inset based on lines title label
        tableViewTopInset += navigationInformationsView.getHeightLabel()*UIView.heightScaleProportion()
        
        tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, buttonsStackView.frame.height, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = refreshIndicatorInTableViewFooter()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInformations()
        setPresenterDelegate()
        setNavigationInformations()
        registerNibs()
        //configureButtons()
        configureTableView()
        if self.presenter.post.isAvailable {
            initializeComposeBar()
            setupKeyboardNotifications()
        }
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
    
    func setFieldExchange(title:String) {
        let fieldExchange = Fields(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: title, descriptionCondition: "ttteste", constraintIconWidth: 14.0*UIView.heightScaleProportion(), constraintIconHeight: 15.0*UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldExchange)
    }
    
    func setFieldTime() {
        let fieldTime = Fields.init(iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: DetailPostTitles.titleTime, descriptionCondition: presenter.post.loanTime!, constraintIconWidth: 16.0*UIView.heightScaleProportion(), constraintIconHeight: 16.0 * UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldTime)
    }
    
    func setFieldPlace(){
        let fieldPlace = Fields.init(iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: DetailPostTitles.titlePlace, descriptionCondition: presenter.post.place!, constraintIconWidth: 15.0*UIView.heightScaleProportion(), constraintIconHeight: 18.0*UIView.heightScaleProportion())
        
        self.inputFieldsCondition.append(fieldPlace)
    }
    
    func setupSubscribe() {
        presenter.subscribeToUpdateComment()
        presenter.subscribeToUpdateLike()
    }
    
    func refreshIndicatorInTableViewFooter() -> UIView {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        viewIndicator.backgroundColor = UIColor.clear
        return viewIndicator
    }
    
    
    func getCommentsCount() {
        presenter.getCommentCounts()
      
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
    
    
    func goToProfile(_ sender: UIButton) {
        self.currentIndexPath = IndexPath(row: sender.tag, section: 0)
        performSegue(withIdentifier: SegueIdentifiers.detailThingToProfile, sender: self)
    }
    
    func setPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureButtons(actionsPostCell: ActionsPostTableViewCell) {
        
        if actionsPostCell.recommendButton.titleLabel?.text == nil {
            if !presenter.post.isAvailable {
                actionsPostCell.isHidden = true
            } else if !presenter.authorPostIsCurrent() {
                actionsPostCell.waitingListButton.titleLabel?.loadAnimation()
                presenter.alreadyInterested(completionHandler: { (success, msg, title) in
                    if success {
                        actionsPostCell.waitingListButton.titleLabel?.unload()
                        actionsPostCell.waitingListButton.setTitle(title, for: .normal)
                    }
                })
                actionsPostCell.recommendButton.isHidden = false
                actionsPostCell.recommendButton.setTitle(presenter.recommendedTitleButton, for: .normal)

            } else {
                //actionsPostCell.recommendButton.isHidden = true
                //actionsPostCell.waitingListButton.backgroundColor = UIColor.colorWithHexString("FBBB47")
                actionsPostCell.waitingListButton.setTitle(presenter.interestedListTitleButton, for: .normal)
                actionsPostCell.recommendButton.setTitle(presenter.recommendedTitleButton, for: .normal)
            }
        }
    }
    
    func setupActionButtons(actionsPostCell: ActionsPostTableViewCell) {
        
        actionsPostCell.recommendButton.addTarget(self, action: #selector(goToRecommendedView(_:)), for: .touchUpInside)
        
        actionsPostCell.waitingListButton.addTarget(self, action: #selector(enterInterestedList(_:)), for: .touchUpInside)
    }
    
    func initializeComposeBar(){
        initialViewFrame = CGRect(x: 0.0, y: self.view.frame.height - PHFComposeBarViewInitialHeight, width: self.view.frame.width, height: PHFComposeBarViewInitialHeight)
        composeBarView = PHFComposeBarView(frame: CGRect(x: 0.0, y: 0.0, width: (initialViewFrame?.size.width)!, height: PHFComposeBarViewInitialHeight))
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
        defaultValueAlphaTitleNavigation = navigationBarView.titleBarLabel.alpha
        navigationBarView.titleBarLabel.text = presenter.getCurrentType()
        if presenter.authorPostIsCurrent() {
            navigationBarView.editButton.addTarget(self, action: #selector(goToEditPost(_:)), for: .touchUpInside)
            navigationBarView.setupEditAction(typePost: presenter.post.typePostEnum ?? TypePostEnum.have, titlePost: presenter.getCurrentType())
        }
        navigationInformationsView.thingNameLabel.text = presenter.post.title ?? ""
        navigationInformationsView.thingNameLabel.setDynamicFont()

        navigationBarView.titleBarLabel.setDynamicFont()
        navigationBarView.leftButton.addTarget(self, action: #selector(backView(_:)), for: .touchUpInside)
        //iPhone X
        if UIScreen.main.bounds.height >= 812.0 {
            thingNavigationBarHeightConstraint.constant += 25.0
            thingBarHeightConstraint.constant += 25.0
        }
    }
    
    func goToEditPost(_ sender: Any){
        performSegue(withIdentifier: SegueIdentifiers.detailThingToEditPost, sender: self)
    }
    
    @IBAction func firstButtonAction(_ sender: Any) {
//        if presenter.authorPostIsCurrent() {
//            performSegue(withIdentifier: SegueIdentifiers.detailThingToInterestedList, sender: self)
//        } else {
//            if self.firstButton.currentTitle == presenter.enterInterestedTitleButton {
//                presenter.enterInterestedList(completionHandler: { (success, <#String#>, <#String#>) in
//                    <#code#>
//                })
//            } else {
//                presenter.exitInterestedList()
//            }
//        }
    }
    
    func enterInterestedList(_ sender: UIButton) {
        if presenter.authorPostIsCurrent() {
            performSegue(withIdentifier: SegueIdentifiers.detailThingToInterestedList, sender: self)
        } else {
            if sender.currentTitle == presenter.enterInterestedTitleButton {
                presenter.enterInterestedList(completionHandler: { (success, msg, title) in
                    sender.setTitle(title, for: .normal)
                })
            } else {
                presenter.exitInterestedList(completionHandler: { (success, msg, title) in
                    sender.setTitle(title, for: .normal)
                })
            }
        }
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.detailThingToRecommended, sender: self)
    }
    
    func goToRecommendedView(_ sender: UIButton) {
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
                        self.view.frame.origin.y = -keyboardFrame.size.height
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
                self.view.frame.origin.y = 0
        },
            completion: nil)
    }
    
    func configureGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didGesture(_:)))
        panGesture.delegate = self
        tableView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didGesture(_:)))
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func didGesture(_ gesture : UIGestureRecognizer) {
        tableView.endEditing(true)
        view.endEditing(true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? InterestedListViewController {
            controller.presenter.setPost(post: presenter.post)
        }
        
        if let controller = segue.destination as? ProfileMainViewController {
            if let index = self.currentIndexPath {
                
                if index.row == authorPostTag {
                    controller.presenter.setProfile(profile: presenter.post.author!)
                } else {
                    controller.presenter.setProfile(profile: presenter.comments[index.row].author!)
                }
                self.currentIndexPath = nil
            } else {
                controller.presenter.setPost(post: presenter.post)
            }
        }
        
        if let controller = segue.destination as? RecommendedViewController {
            controller.presenter.post = presenter.post
        }
        
        if let controller = segue.destination as? ThrowViewController {
            setupThrowViewControllerInfo(controller: controller)
        }
    }
    
    func setupThrowViewControllerInfo(controller: ThrowViewController){
        controller.typeVC = presenter.post.typePostEnum ?? TypePostEnum.have
        controller.titleHeader = presenter.getCurrentType()
        
        //Get Images
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotoThingTableViewCell {
            let numberPhotos = cell.photoCollectionView.numberOfItems(inSection: 0)
            for row in 0...(numberPhotos - 1) {
                let imagePost = cell.presenter.getImagePostByIndex(row)
                controller.allImages.append(imagePost)
            }
        }
        
        controller.setupEditablePost(post: presenter.post)
    }
    
    func generateMoreButton(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreCommentTableViewCell.identifier, for: indexPath) as! MoreCommentTableViewCell
        
        cell.moreButton.addTarget(self, action: #selector(updateComments(_:)), for: .touchUpInside)
        
        cell.moreButton.setTitle(setupMoreButtonTitle(), for: .normal)
        
        cell.moreButton.isEnabled = true
        
        if presenter.commentCount <= 0 {
            commentCount = presenter.commentCount
        }
        
        return cell
    }
    
    func setupMoreButtonTitle() -> String {
        let commentsMissing = presenter.commentCount
        var moreButtonTitle: String
        
        if commentsMissing == 1 {
            moreButtonTitle = "Ver mais \(commentsMissing.description) comentário"
        } else {
            moreButtonTitle = "Ver mais \(commentsMissing.description) comentários"
        }
        
        return moreButtonTitle
    }
    
    func generatePhotoThingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoThingTableViewCell.identifier, for: indexPath) as! PhotoThingTableViewCell
        
        cell.presenter.post = presenter.post
        cell.delegate = self
    
        
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
        cell.userButton.tag = authorPostTag
        cell.userButton.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
        cell.updateCellUI()
        
        return cell
    }
    
    func generateAmountPostInteractionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AmountPostInteractionTableViewCell.identifier, for: indexPath) as! AmountPostInteractionTableViewCell
        
        cell.presenter.post = presenter.post
        cell.presenter.getLikeAmount(isSelectedButton: nil)
        cell.presenter.getCommentAmount()
        cell.presenter.getRecommendationAmount()
        cell.presenter.verifyIsLiked()
        
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
        cell.cellData = inputFieldsCondition[indexPath.row-4]
        
        return cell
    }
    
    
    
    func generateUserCommentCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCommentTableViewCell.identifier, for: indexPath) as! UserCommentTableViewCell
        
        var index: Int?
        
        if commentCount! > 0 {
            index = (presenter.comments.count-1)-(indexPath.row-inputFieldsCondition.count-6)
        } else {
            index = (presenter.comments.count-1)-(indexPath.row-inputFieldsCondition.count-5)
        }
        
        cell.comment = presenter.comments[index!]
        cell.profileButton.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
        cell.profileButton.tag = index!
        
        return cell
    }
    
    
    func generateActionsPostsCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionsPostTableViewCell.identifier, for: indexPath) as! ActionsPostTableViewCell
            
            configureButtons(actionsPostCell: cell)
            setupActionButtons(actionsPostCell: cell)
        
//        presenter.getWaitingListAmount { (success, msg, amount) in
//            if amount != 0 {
//                cell.setupWaitingListAmount(amount: amount)
//            }
//        }
        
        return cell
    }
    
    func textFieldFirstResponder(_ sender: UIButton) {
        composeBarView?.becomeFirstResponder()
    }
    func openDetailPhoto(_ sender: UIButton) {
        
   
    }
}

extension ThingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case inputFieldsCondition.count+4:
            if !presenter.post.isAvailable {
               return 0.1
            } else {
                return UITableViewAutomaticDimension
            }
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
            return generateAmountPostInteractionCell(tableView, cellForRowAt: indexPath)
        case 3:
            return generateUserDescriptionCell(tableView, cellForRowAt: indexPath)
        case 4..<inputFieldsCondition.count+4:
            return generateConditionCell(tableView, cellForRowAt: indexPath)
        case inputFieldsCondition.count+4:
            return generateActionsPostsCell(tableView, cellForRowAt: indexPath)
        case inputFieldsCondition.count+5:
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
        
        let rows = inputFieldsCondition.count + 5 + presenter.comments.count
        let rowsWithMoreButton = inputFieldsCondition.count + 6 + presenter.comments.count
        
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
        updateNavigationBarView(yOffset)
        updateInformationsCell(yOffset)
    }
    
    func updateNavigationBarView(_ yOffset: CGFloat) {
        if yOffset > 0 {
            let newAlpha = 1 - ((yOffset)/self.navigationBarView.frame.size.height*2)
            if newAlpha < self.defaultValueAlphaTitleNavigation {
                self.navigationBarView.titleBarLabel.alpha = newAlpha
            }
        } else {
            self.navigationBarView.titleBarLabel.alpha = self.defaultValueAlphaTitleNavigation
        }
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
    
    func startFooterLoading() {
         tableView.tableFooterView?.loadAnimation(0.2, UIColor.white, UIActivityIndicatorViewStyle.gray, 1.0)
    }
    
    func finishFooterLoading() {
        self.tableView.tableFooterView?.unload()
    }
    
    func reload() {
//        if presenter.comments.count != presenter.currentCommentsCount {
            tableView.reloadData()
//        }
    }
    
    func showMessage(isSuccess: Bool, msg: String) {
        let title = isSuccess ? "" : "Erro: "
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: title + msg, negativeAction: "Ok") { (isPositive) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ThingDetailViewController: PHFComposeBarViewDelegate {
    
    func composeBarViewDidPressButton(_ composeBarView: PHFComposeBarView!) {
        
        let letters = CharacterSet.letters
        
        if composeBarView.text != "" && composeBarView.text != "\n" && composeBarView.text.rangeOfCharacter(from: letters) != nil {
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

extension ThingDetailViewController:PhotoDetailDelegate {
    
    func displayPhoto(){
        if let nextVC = ViewUtil.viewControllerFromStoryboardWithIdentifier("Home", identifier:"editImageVC") as? EditImageViewController{
            nextVC.photo = presenter.getImagePostByIndex(0)
            let transition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
  }





