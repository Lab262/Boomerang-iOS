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

    @IBOutlet weak var navigationBar: IconNavigationBar!
    @IBOutlet weak var bgPostImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var anexPhotoButton: UIButtonWithPicker!
    
    //Informations form
    var fields:[Int:String] = [:]
    var params:[String:String] = [:]
    var typeVC = TypePost.have
    var typeScheme:Condition?
    var isAvailable:Bool?
    
    var titleHeader = String()
    var allimages:[UIImage]?
    
    var headerHeight = CGFloat(200)
    
    let defaultSize16:CGFloat = 16
    let defaultSize14:CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
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
        tableView.registerNibFrom(HeaderPostTableViewCell.self)
        
    }

    
    
    @IBAction func throwAction(_ sender: Any) {
        
        parseFields()
        
        if let msgErro = self.verifyEmptyParams() {
            self.present(ViewUtil.alertControllerWithTitle(title: "Erro", withMessage: msgErro), animated: true, completion: nil)
            return
        }
//
//        self.createPost()
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
    
    func generateHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: HeaderPostTableViewCell.identifier) as! HeaderPostTableViewCell
      
        header.backButton.addTarget(self, action:#selector(backAction(_:)), for:.touchUpInside)
        header.delegate = self
        
        if let images = allimages {
            header.highlights = images
            header.titleLabel.text = ""
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header: UIView?
        
        switch section {
            case 0: header = generateHeaderView(tableView, viewForHeaderInSection: section)
            default: header = nil
        }
        
        return header
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
        let post = Post()
        
        let pictureData = UIImagePNGRepresentation((allimages?.first)!)
        let pictureFileObject = PFFile (data:pictureData!)
        
        post.author = ApplicationState.sharedInstance.currentUser?.profile
//        post.title =  self.nameThing
//        post.content = self.descriptionThing
        post.typePost = TypePost(rawValue: typeVC.rawValue)
        post.type = post.typePost.map { $0.rawValue }
      
        ActivitIndicatorView.show(on: self)
        
        let photos = PFObject(className:"Photo")
        photos["imageFile"] = pictureFileObject
        
        photos.saveInBackground(block: { (success, error) in
            if success {
                let relation = post.relation(forKey: "photos")
                
                relation.add(photos)
                
                post.saveInBackground(block: { (success, error) in
                    if success {
                        AlertUtils.showAlertError(title:"Arrmessado com sucesso", viewController:self)
                        ActivitIndicatorView.hide(on:self)

                        //self.view.unload()
                    }else {
                        AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
                        ActivitIndicatorView.hide(on:self)
                    }
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


extension ThrowViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        print("aqui ------>",offsetY)
      
        
    }
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
}

extension ThrowViewController: UIIButtonWithPickerDelegate{
    
    
    func didPickEditedImage(image: [UIImage]){
        allimages = image
        self.tableView.reloadData()
    }

}



