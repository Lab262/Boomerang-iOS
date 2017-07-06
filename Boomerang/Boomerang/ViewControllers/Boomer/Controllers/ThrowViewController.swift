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
    
    var presenter: ThrowPresenter = ThrowPresenter()
    var isAvailable:Bool?
    var boolTypeScheme:Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var coverPostHeightConstraint: NSLayoutConstraint!
    
    var titleHeader = String()
    let defaultSize16: CGFloat = 16
    let defaultSize14: CGFloat = 14
    let navigationBarHeight: CGFloat = 64
    let coverImageHeight: CGFloat = 165.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupTableViewConfigurations()
        setupAnexButtonDelegate()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TabBarController.mainTabBarController.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TabBarController.mainTabBarController.showTabBar()
    }
    
    func setupAnexButtonDelegate() {
        self.anexButton.delegate = self
        self.anexAreaButton.delegate = self
    }
    
    func setupTableViewConfigurations() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsetsMake(coverImageHeight - navigationBarHeight, 0, 0, 0)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
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
                self.tableView.contentInset =  UIEdgeInsetsMake(self.coverImageHeight - self.navigationBarHeight, 0, 0, 0)
                self.anexButton.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
        },
            completion: nil)
    }
    
    @IBAction func throwAction(_ sender: Any) {
        
        presenter.parseFields()
        
        if let msgErro = presenter.verifyEmptyParams() {
            self.present(ViewUtil.alertControllerWithTitle(title: "Erro", withMessage: msgErro), animated: true, completion: nil)
            return
        }
        
        presenter.createPost()
    }
    
    //MARK: Generate Tables Views Cells
    
    func generateHeadPostCell (_ tableView: UITableView, indexPath: IndexPath, image: UIImage) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:TypePostTableViewCell.identifier, for: indexPath) as! TypePostTableViewCell
  
        cell.imagePost.image = image
        cell.titlePostString = titleHeader
        
        return cell
        
    }
    
    func generateNavigation(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HeaderPostTableViewCell.identifier, for: indexPath) as! HeaderPostTableViewCell
   
        cell.backButton.addTarget(self, action:#selector(backAction(_:)), for:.touchUpInside)
        return cell
        
    }
    
    func generateDescriptionCell (_ tableView: UITableView, indexPath: IndexPath, titleCell: String, sizeFont: CGFloat) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTextTableViewCell.identifier, for: indexPath) as! DescriptionTextTableViewCell
        
        
        cell.titleLabel.text = titleCell
        cell.defaultSizeFont = sizeFont
        
        cell.handler!.completion = { (text) -> Void in
            self.presenter.fields[indexPath.row] = text
        }
        return cell
        
    }
    
    func generateSwitchButtonCell (_ tableView: UITableView, indexPath: IndexPath, firstTitle: String, secondTitle: String, isTypeScheme:Bool) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SwitchButtonTableViewCell.identifier, for: indexPath) as! SwitchButtonTableViewCell
    
        cell.firstOptionTitle = firstTitle
        cell.secondOptionTitle = secondTitle

        cell.handlerOptionSelected = { selected in
            if isTypeScheme {
                if selected {
                    self.presenter.typeScheme = ConditionEnum.loan
                } else{
                    self.presenter.typeScheme = ConditionEnum.exchange
                }
                self.boolTypeScheme = selected
            } else{
                self.isAvailable = selected
            }
        }
        
        if isTypeScheme {
            cell.isFirstOptionSelected = self.boolTypeScheme
            //tableView.reloadData()
        } else{
            cell.isFirstOptionSelected = self.isAvailable
        }
        
        return cell
        
    }
    
    func generateSimpleTextFieldCell(_ tableView: UITableView, indexPath: IndexPath, title: String, placeholder: String) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.identifier, for: indexPath) as! SimpleTextFieldTableViewCell
        
        cell.titleLabel.text = title
        cell.textField.placeholder = placeholder
        
        cell.handler!.completion = { (text) -> Void in
            self.presenter.fields[indexPath.row] = text
        }
        
        return cell
        
    }

    //MARK: Generate Tables Views
    
    func generateTableViewNeed(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if boolTypeScheme {
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
                // se for emprestado
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
        } else {
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
                return generateDescriptionCell(tableView, indexPath:indexPath, titleCell: CreatePostTitles.titleChangeBorrowed, sizeFont: defaultSize14)
            case 5:
                return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
            case 6:
                return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func generateTableViewHave(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if boolTypeScheme {
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
                return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
            case 6:
                return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
            default:
                return UITableViewCell()
            }
        } else {
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
                return generateSimpleTextFieldCell(tableView, indexPath:indexPath, title: CreatePostTitles.titlePlace, placeholder: CreatePostTitles.placeholderConversation)
            case 5:
                return generateSwitchButtonCell(tableView, indexPath:indexPath, firstTitle: CreatePostTitles.validated, secondTitle: CreatePostTitles.notValidated, isTypeScheme: false)
            default:
                return UITableViewCell()
            }
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
}

extension ThrowViewController: UITableViewDataSource {
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.typePost {
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
                    self.anexAreaButton.isEnabled = false
                })
            }
          
        } else {
            if self.anexButton.alpha == 0.0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.anexButton.alpha = 1.0
                    self.anexAreaButton.isEnabled = true
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
    
    
    func didPickEditedImage(images: [UIImage]){
        presenter.images = images
        addTitleLabel.isHidden = true
        iconCameraView.isHidden = true
        coverPostImage.image = images[0]
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



