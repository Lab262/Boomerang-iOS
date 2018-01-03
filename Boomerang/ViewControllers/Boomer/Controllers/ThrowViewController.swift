//
//  ThrowViewController.swift
//  Boomerang
//
//  Created by Felipe perius on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


class ThrowViewController: UIViewController {

    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverPostImage: UIImageView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var iconCameraView: UIImageView!
    @IBOutlet weak var extentAnexButton: UIButton!
    @IBOutlet weak var coverPostTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var anexButton: UIButtonWithPicker!
    @IBOutlet weak var anexButtonCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var anexAreaButton: UIButtonWithPicker!
    @IBOutlet weak var collectionView: UICollectionView!
    var defaultValueAlphaTitleNavigation:CGFloat = 1.0
    
    var fields:[Int:String] = [:]
    var nameThing = String ()
    var descriptionThing = String ()
    var params:[String:String] = [:]
    var typeVC = TypePostEnum.have
    var typeScheme:ConditionEnum?
    var isAvailable:Bool?
    var boolTypeScheme:Bool?
    var editablePost: Post?
    
    var isNeedToGiveSomething = false
    
    @IBOutlet weak var coverPostHeightConstraint: NSLayoutConstraint!
    var titleHeader = String()
    var allImages = [UIImage]()
    
    var headerHeight = CGFloat(200)
    
    let defaultSize16:CGFloat = 16
    let defaultSize14:CGFloat = 14
    let navigationBarHeight: CGFloat = 64
    let coverImageHeight: CGFloat = 165.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupTableView()
        setupDelegates()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func setupDelegates() {
        self.anexButton.delegate = self
        self.anexAreaButton.delegate = self
    }
    
    
    @IBAction func backAction(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         TabBarController.mainTabBarController.showTabBar()

    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func registerNib() {
        tableView.registerNibFrom(SwitchButtonTableViewCell.self)
        tableView.registerNibFrom(SimpleTextFieldTableViewCell.self)
        tableView.registerNibFrom(DescriptionTextTableViewCell.self)
        tableView.registerNibFrom(TypePostTableViewCell.self)
        tableView.registerNibFrom(HeaderPostTableViewCell.self)
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
                        self.anexButton.isHidden = true
                        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)
                        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                        self.tableView.scrollToRow(at: IndexPath.init(row: 3, section: 0) , at: .bottom, animated: true)
                       
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
                self.anexButton.isHidden = false
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                self.anexButton.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }

    
    
    @IBAction func throwAction(_ sender: Any) {
        
        parseFields()
        
        if let msgErro = self.verifyEmptyParams() {
            GenericBoomerAlertController.presentMe(inParent: self, withTitle: msgErro, negativeAction: "Ok") { (isPositive) in
                self.dismiss(animated: true, completion: nil)
            }
            return
        }

        self.createOrUpdatePost()
        
    }
    
    //MARK: Generate Tables Views Cells
    
    func generateTypeIconPostCell (_ tableView: UITableView, indexPath: IndexPath, image: UIImage) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:TypePostTableViewCell.identifier, for: indexPath) as! TypePostTableViewCell
        cell.selectionStyle = .none
        cell.imagePost.image = image
        cell.titlePostString = titleHeader
        
        return cell
        
    }
    
    func generateHeaderPostCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HeaderPostTableViewCell.identifier, for: indexPath) as! HeaderPostTableViewCell
        
        if allImages.count > 0 {
            cell.photos = allImages
        }

        return cell
    }
    
    func generateDescriptionCell (_ tableView: UITableView, indexPath: IndexPath, titleCell: String, sizeFont: CGFloat) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTextTableViewCell.identifier, for: indexPath) as! DescriptionTextTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = titleCell
        cell.defaultSizeFont = sizeFont
        
        if self.fields[indexPath.row] != "" &&  self.fields[indexPath.row] != nil {
            cell.textView.text = self.fields[indexPath.row]
        }
        
        cell.handler!.completion = { (text) -> Void in
            self.fields[indexPath.row] = text
        }
        return cell
        
    }
    
    func generateSwitchButtonCell (_ tableView: UITableView, indexPath: IndexPath, firstTitle: String, secondTitle: String, isTypeScheme:Bool) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SwitchButtonTableViewCell.identifier, for: indexPath) as! SwitchButtonTableViewCell
        
        cell.selectionStyle = .none
        cell.firstOptionTitle = firstTitle
        cell.secondOptionTitle = secondTitle

        cell.handlerOptionSelected = {selected in
            
            if isTypeScheme {
                if selected {
                    self.typeScheme = ConditionEnum.loan
                }else{
                    self.typeScheme = ConditionEnum.exchange
                }
                self.boolTypeScheme = selected
            }else{
                self.isAvailable = selected
            }
        }
        
        if isTypeScheme {
            cell.isFirstOptionSelected = self.boolTypeScheme
        }else{
            cell.isFirstOptionSelected = self.isAvailable
        }

        return cell
        
    }
    
    func generateSimpleTextFieldCell (_ tableView: UITableView, indexPath: IndexPath, title: String, placeholder: String, isTitlePost:Bool=false) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.identifier, for: indexPath) as! SimpleTextFieldTableViewCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = title
        cell.textField.placeholder = placeholder
        
        if self.fields[indexPath.row] != "" &&  self.fields[indexPath.row] != nil {
            cell.textField.text = self.fields[indexPath.row]
        }
        
        cell.handler!.completion = { (text) -> Void in
            self.fields[indexPath.row] = text
        }
        
        //Verify it is Title Post Cell
        if isTitlePost {
            cell.setupTextFieldDelegate()
        }
        
        return cell
    }
    
    //MARK: Generate Tables Views
    
    func generateTableViewNeed(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            return generateHeaderPostCell(tableView, indexPath:indexPath)
        case  1:
            return generateTypeIconPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_need"))
        case  2:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.borrowed, secondTitle: CreatePostTitles.toSwitch, isTypeScheme: true)
        case 3:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleNeed, placeholder: CreatePostTitles.placeholderTitleNeed, isTitlePost: true)
        case 4:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 5:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHowLong, placeholder: CreatePostTitles.placeholderConversation)
        case 6:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleChangeBorrowed, sizeFont: defaultSize14)
        case 7:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
        case 8:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
        default:
            return UITableViewCell()
        }
    }
    
    func generateTableViewHave(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            return generateHeaderPostCell(tableView, indexPath:indexPath)
        case 1:
            return generateTypeIconPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_have"))
        case 2:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.borrowed, secondTitle: CreatePostTitles.toSwitch, isTypeScheme: true)
        case 3:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHave, placeholder: CreatePostTitles.placeholderTitleHave, isTitlePost: true)
        case 4:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 5:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHowLong, placeholder: CreatePostTitles.placeholderConversation)
        case 6:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
        case 7:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
        default:
            return UITableViewCell()
        }
    }
    
    func generateTableViewDonate(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            return generateHeaderPostCell(tableView, indexPath:indexPath)
        case 1:
            return generateTypeIconPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_donate"))
        case 2:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleDonate, placeholder: CreatePostTitles.placeholderTitleDonate, isTitlePost: true)
        case 3:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 4:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
        case 5:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
        default:
            return UITableViewCell()
        }
    }
    
    //MARK: Parse Fields
    func parseFields(){
        switch typeVC {
        case .need, .have, .all:
            parseFieldsNeedOrHave()
        case .donate:
            parseFieldsDonate()
        }
    }
    
    func parseFieldsNeedOrHave(){
        self.params[CreatePostTitles.keyParseTitle] = self.fields[3]
        self.params[CreatePostTitles.keyParseContent] = self.fields[4]
        self.params[CreatePostTitles.keyParseTime] = self.fields[5]
        
        if typeVC == .need {
            self.params[CreatePostTitles.keyParseExchangeDescription] = self.fields[6]
            self.params[CreatePostTitles.keyParsePlace] = self.fields[7]
        } else {
            self.params[CreatePostTitles.keyParsePlace] = self.fields[6]
        }
    }
    
    func parseFieldsDonate(){
        self.params[CreatePostTitles.keyParseTitle] = self.fields[2]
        self.params[CreatePostTitles.keyParseContent] = self.fields[3]
        self.params[CreatePostTitles.keyParsePlace] = self.fields[4]
    }
    
    func verifyEmptyParams() -> String? {
        var msgErro: String?
        
        
        if allImages.count < 1 {
            msgErro = CreatePostTitles.msgErrorImage
            return msgErro
        }
     
        if typeVC == .need || typeVC == .have {
            if typeScheme == nil {
                msgErro = CreatePostTitles.msgErrorTypeScheme
                return msgErro
            }
        }
        
        if self.params[CreatePostTitles.keyParseTitle] == nil || self.params[CreatePostTitles.keyParseTitle] == "" {
            msgErro = CreatePostTitles.msgErrorTitle
            return msgErro
        }
        
        if self.params[CreatePostTitles.keyParseContent] == nil || self.params[CreatePostTitles.keyParseContent] == "" {
            msgErro = CreatePostTitles.msgErrorDescription
            return msgErro
        }
        
        if self.params[CreatePostTitles.keyParsePlace] == "" || self.params[CreatePostTitles.keyParsePlace] == nil {
            self.params[CreatePostTitles.keyParsePlace] = "Na base da conversa"
        }
        
        if self.params[CreatePostTitles.keyParseTime] == "" || self.params[CreatePostTitles.keyParseTime] == nil {
            self.params[CreatePostTitles.keyParseTime] = "Na base da conversa"
        }
        
        if self.isAvailable == nil {
            msgErro = CreatePostTitles.msgErrorIsAvailable
            return msgErro
        }
        
        if typeVC == .need {
            if self.params[CreatePostTitles.keyParseExchangeDescription] == nil || self.params[CreatePostTitles.keyParseExchangeDescription] == "" {
                msgErro = CreatePostTitles.msgErrorExchangeDescription
                return msgErro
            }
        }
        
        return msgErro
    }
    
    func createOrUpdatePost() {
        self.view.endEditing(true)
        
        if let profile = User.current()!.profile, let title = params[CreatePostTitles.keyParseTitle], let content = params[CreatePostTitles.keyParseContent], let place = params[CreatePostTitles.keyParsePlace] {
            
            var post = self.editablePost
            
            if post == nil {
                post = Post()
            }
            
            post?.setup(author: profile,
                        title: title,
                        content: content,
                        loanTime: params[CreatePostTitles.keyParseTime],
                        exchangeDescription: params[CreatePostTitles.keyParseExchangeDescription],
                        place: place,
                        condition: typeScheme,
                        typePost: typeVC)
            
            var allFilesObject = [PFObject]()
            
            for image in allImages {
                if let pictureData = UIImageJPEGRepresentation(image, 0.2) {
                    let pictureFileObject = PFFile(data: pictureData, contentType: "image/jpeg")
                    let photo = PFObject(className: "Photo")
                    photo["imageFile"] = pictureFileObject
                    allFilesObject.append(photo)
                }
            }
            
            self.view.loadAnimation()
            
            PFObject.saveAll(inBackground: allFilesObject) { (success, error) in
                if success {
                    let relation = post?.relation(forKey: "photos")
                    
                    //Removing older relations
                    let relationQuery = relation?.query()
                    var objectArray: [PFObject]?
                    
                    do {
                        objectArray = try relationQuery?.findObjects()
                    } catch {
                        objectArray = nil
                    }
                    
                    if let objectArray = objectArray {
                        for object in objectArray {
                            relation?.remove(object)
                        }
                    }
                    
                    //Adding new relations
                    for fileObject in allFilesObject {
                        relation?.add(fileObject)
                    }
                    
                    post?.saveInBackground(block: { (success, error) in
                        if success {
                            self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Boomer", identifier: "feedbackCreatePost")!, animated: true, completion: nil)
                        } else {
                            GenericBoomerAlertController.presentMe(inParent: self, withTitle: "Algo deu errado.", negativeAction: "Ok") { (isPositive) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            ActivitIndicatorView.hide(on:self)
                        }
                        
                        self.view.unload()
                    })
                }
            }
        }
    }
}

extension ThrowViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeVC == .need ? 9 : 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch typeVC {
        case .need, .all:
            return generateTableViewNeed(tableView, cellForRowAt: indexPath)
        case .have:
            return generateTableViewHave(tableView, cellForRowAt: indexPath)
        case .donate:
            return generateTableViewDonate(tableView, cellForRowAt: indexPath)
        }
    }
}


extension ThrowViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        updateInformationsCell(yOffset)
        updateNavigationBarView(yOffset)
    }
    
    func updateInformationsCell(_ yOffset: CGFloat) {
        if yOffset > 0 {
            if self.anexButton.alpha == 1.0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.anexButton.alpha = 0.0
                })
            }
        } else {
            if self.anexButton.alpha == 0.0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.anexButton.alpha = 1.0
                })
            }
        }
    }
    
    func updateNavigationBarView(_ yOffset: CGFloat) {
        if yOffset > 0 {
            let newAlpha = 1 - ((yOffset)/self.navigationBarView.frame.size.height*2)
            if newAlpha < self.defaultValueAlphaTitleNavigation {
                self.navigationBarView.alpha = newAlpha
            }
        } else {
            self.navigationBarView.alpha = self.defaultValueAlphaTitleNavigation
        }
    }

}

extension ThrowViewController: UIIButtonWithPickerDelegate{
    func didPickEditedImage(image: [UIImage]){
        allImages = image
        self.tableView.reloadData()
    }

}
extension ThrowViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Editable Post
extension ThrowViewController {
    func setupEditablePost (post: Post) {
        self.editablePost = post
        self.typeScheme = self.editablePost?.postConditionEnum
        self.setupFields()
    }
    
    private func setupFields(){
        switch typeVC {
        case .need, .have, .all:
            setupFieldsNeedOrHave()
        case .donate:
            setupFieldsDonate()
        }
        self.isAvailable = self.editablePost?.isAvailable
    }
    
    private func setupFieldsNeedOrHave(){
        self.fields[3] = self.editablePost?.title
        self.fields[4] = self.editablePost?.content
        self.fields[5] = self.editablePost?.loanTime
        
        if typeVC == .need {
            self.fields[6] = self.editablePost?.exchangeDescription
            self.fields[7] = self.editablePost?.place
        } else {
            self.fields[6] = self.editablePost?.place
        }
        
        if self.typeScheme == ConditionEnum.loan {
            self.boolTypeScheme = true
        }else if self.typeScheme == ConditionEnum.exchange {
            self.boolTypeScheme = false
        }
    }
    
    private func setupFieldsDonate(){
        self.fields[2] = self.editablePost?.title
        self.fields[3] = self.editablePost?.content
        self.fields[4] = self.editablePost?.place
    }
}

