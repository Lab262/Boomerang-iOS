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
    
    var fields:[Int:String] = [:]
    var nameThing = String ()
    var descriptionThing = String ()
    var params:[String:String] = [:]
    var typeVC = TypePost.have
    var typeScheme:Condition?
    var isAvailable:Bool?
    
    @IBOutlet weak var coverPostHeightConstraint: NSLayoutConstraint!
    var titleHeader = String()
    var allimages:[UIImage]?
    
    var headerHeight = CGFloat(200)
    
    let defaultSize16:CGFloat = 16
    let defaultSize14:CGFloat = 14
    let navigationBarHeight: CGFloat = 64
    let coverImageHeight: CGFloat = 165.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsetsMake(coverImageHeight - navigationBarHeight, 0, 0, 0)
        self.anexButton.delegate = self
        self.anexAreaButton.delegate = self
        self.hideKeyboardWhenTappedAround()
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
    
    func registerNib() {
        
        tableView.registerNibFrom(SwitchButtonTableViewCell.self)
        tableView.registerNibFrom(SimpleTextFieldTableViewCell.self)
        tableView.registerNibFrom(DescriptionTextTableViewCell.self)
        tableView.registerNibFrom(TypePostTableViewCell.self)
      //  tableView.registerNibFrom(HeaderPostTableViewCell.self)

    }

    
    
    @IBAction func throwAction(_ sender: Any) {
        
        parseFields()
        
        if let msgErro = self.verifyEmptyParams() {
            self.present(ViewUtil.alertControllerWithTitle(title: "Erro", withMessage: msgErro), animated: true, completion: nil)
            return
        }

        self.createPost()
    }
    
    //MARK: Generate Tables Views Cells
    
    func generateHeadPostCell (_ tableView: UITableView, indexPath: IndexPath, image: UIImage) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:TypePostTableViewCell.identifier, for: indexPath) as! TypePostTableViewCell
        cell.selectionStyle = .none
        cell.imagePost.image = image
        cell.titlePostString = titleHeader
        
        return cell
        
    }
    
    func generateNavigation(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HeaderPostTableViewCell.identifier, for: indexPath) as! HeaderPostTableViewCell
        cell.selectionStyle = .none
        cell.backButton.addTarget(self, action:#selector(backAction(_:)), for:.touchUpInside)
        return cell
        
    }
    
    func generateDescriptionCell (_ tableView: UITableView, indexPath: IndexPath, titleCell: String, sizeFont: CGFloat) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTextTableViewCell.identifier, for: indexPath) as! DescriptionTextTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = titleCell
        cell.defaultSizeFont = sizeFont
        
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
                    self.typeScheme = Condition.loan
                }else{
                    self.typeScheme = Condition.exchange
                }
            }else{
                self.isAvailable = selected
            }
            
            cell.isFirstOptionSelected = selected
        }
        
        return cell
        
    }
    
    func generateSimpleTextFieldCell (_ tableView: UITableView, indexPath: IndexPath, title: String, placeholder: String) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.identifier, for: indexPath) as! SimpleTextFieldTableViewCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = title
        cell.textField.placeholder = placeholder
        
        cell.handler!.completion = { (text) -> Void in
            self.fields[indexPath.row] = text
        }
        
        return cell
        
    }

    
    //MARK: Generate Tables Views
    
    func generateTableViewNeed(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case  0:
            return generateHeadPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_need"))
        case  1:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.borrowed, secondTitle: CreatePostTitles.toSwitch, isTypeScheme: true)
        case 2:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleNeed, placeholder: CreatePostTitles.placeholderTitleNeed)
        case 3:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 4:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHowLong, placeholder: CreatePostTitles.placeholderConversation)
        case 5:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleChangeBorrowed, sizeFont: defaultSize14)
        case 6:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
        case 7:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
        default:
            return UITableViewCell()
        }
    }
    
    func generateTableViewHave(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case  0:
            return generateHeadPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_have"))
        case  1:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.borrowed, secondTitle: CreatePostTitles.toSwitch, isTypeScheme: true)
        case 2:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHave, placeholder: CreatePostTitles.placeholderTitleHave)
        case 3:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 4:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleHowLong, placeholder: CreatePostTitles.placeholderConversation)
        case 5:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleChangeBorrowed, sizeFont: defaultSize14)
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
        case  0:
            return generateHeadPostCell(tableView, indexPath:indexPath, image: #imageLiteral(resourceName: "ic_donate"))
        case  1:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titleDonate, placeholder: CreatePostTitles.placeholderTitleDonate)
        case 2:
            return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleDescription, sizeFont: defaultSize16)
        case 3:
            return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
        case 4:
            return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
        default:
            return UITableViewCell()
        }
    }
    
    //MARK: Parse Fields
    func parseFields(){
        switch typeVC {
        case .need, .have:
            parseFieldsNeedOrHave()
        case .donate:
            parseFieldsDonate()
        }
    }
    
    func parseFieldsNeedOrHave(){
        self.params[CreatePostTitles.keyParseTitle] = self.fields[2]
        self.params[CreatePostTitles.keyParseContent] = self.fields[3]
        self.params[CreatePostTitles.keyParseTime] = self.fields[4]
        self.params[CreatePostTitles.keyParseExchangeDescription] = self.fields[5]
        self.params[CreatePostTitles.keyParsePlace] = self.fields[6]
    }
    
    func parseFieldsDonate(){
        self.params[CreatePostTitles.keyParseTitle] = self.fields[1]
        self.params[CreatePostTitles.keyParseContent] = self.fields[2]
        self.params[CreatePostTitles.keyParsePlace] = self.fields[3]
    }
    
    func verifyEmptyParams() -> String? {
        var msgErro: String?
        
        if allimages?.first == nil {
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
        
        if self.params[CreatePostTitles.keyParsePlace] == nil || self.params[CreatePostTitles.keyParsePlace] == "" {
            msgErro = CreatePostTitles.msgErrorPlace
            return msgErro
        }
        
        if self.isAvailable == nil {
            msgErro = CreatePostTitles.msgErrorIsAvailable
            return msgErro
        }
        
        return msgErro
    }
    
    
    func createPost () {
        
        self.view.endEditing(true)
        let post = Post(author:
            ApplicationState.sharedInstance.currentUser!.profile!,
                        title: params[CreatePostTitles.keyParseTitle]!,
                        content: params[CreatePostTitles.keyParseContent]!,
                        loanTime: params[CreatePostTitles.keyParseTime],
                        exchangeDescription: params[CreatePostTitles.keyParseExchangeDescription],
                        place: params[CreatePostTitles.keyParsePlace]!,
                        condition: typeScheme,
                        typePost: typeVC)
        
        let pictureData = UIImageJPEGRepresentation((allimages?.first)!, 0.2)
        let pictureFileObject =  PFFile(data: pictureData!, contentType: "image/jpeg")
        
        let photos = PFObject(className:"Photo")
        
        photos["imageFile"] = pictureFileObject
        
        self.view.loadAnimation()
        
        photos.saveInBackground(block: { (success, error) in
            if success {
                let relation = post.relation(forKey: "photos")
                
                relation.add(photos)
                
                post.saveInBackground(block: { (success, error) in
                    if success {
                        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Boomer", identifier: "feedbackCreatePost")!, animated: true, completion: nil)
                        
                        //self.view.unload()
                    }else {
                        AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
                        ActivitIndicatorView.hide(on:self)
                    }
                    
                    self.view.unload()
                })
                
                
            }else {
                AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
                self.view.unload()
            }
        })
    }
    
}

extension ThrowViewController: UITableViewDataSource {
    // MARK: - Table view data source
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch typeVC {
        case .need:
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
        updateImageScale(yOffset)
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
        //let informationAlphaThreshold: CGFloat = 20.0
        
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
        
        if yOffset > 98 {
            if self.iconCameraView.alpha == 1.0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.iconCameraView.alpha = 0.0
                })
            }
        } else {
            if self.iconCameraView.alpha == 0.0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.iconCameraView.alpha = 1.0
                })
            }
        }
    }
 
    func updateImageScale(_ yOffset: CGFloat) {
        
        if yOffset < 0 {
            coverPostHeightConstraint.constant = coverImageHeight - yOffset
        } else if coverPostHeightConstraint.constant != coverImageHeight {
            coverPostHeightConstraint.constant = coverImageHeight
            
        } else if yOffset <= coverImageHeight - navigationBarHeight {
            coverPostTopConstraint.constant = -(yOffset * 0.5)
            anexButtonCenterYConstraint.constant = +(yOffset * 0.5)
            
        }
        
    }
}

extension ThrowViewController: UIIButtonWithPickerDelegate{
    
    
    func didPickEditedImage(image: [UIImage]){
        allimages = image
        self.addTitleLabel.isHidden = true
        self.iconCameraView.isHidden = true
        self.coverPostImage.image = image[0]
       // self.tableView.reloadData()
    }

}
extension ThrowViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThrowViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



