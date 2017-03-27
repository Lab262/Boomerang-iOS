//
//  ThingDetailViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol UpdateCellHeightDelegate {
    func updateCellBy(height: CGFloat)
}

class ThingDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationInformationsView: ThingNavigationBar!
    @IBOutlet weak var navigationBarView: IconNavigationBar!
    
    let tableViewTopInset: CGFloat = 156.0
    var textFieldHeight: CGFloat = 60
    var composeBarView: PHFComposeBarView?
    var container: UIView?
    var keyboardFrameSize: CGRect?
    var initialViewFrame: CGRect?
    
    
    //let bottomMargin: CGFloat = 20.0
    
    
    
    var inputFieldsCondition = [(iconCondition: #imageLiteral(resourceName: "exchange-icon"), titleCondition: "Posso trocar/emprestar", descriptionCondition: "Tenho uma mesa de ping pong aqui parada. ou então bora conversar.", constraintIconWidth: 14.0, constraintIconHeight: 15.0), (iconCondition:#imageLiteral(resourceName: "time-icon"), titleCondition: "Tempo que preciso emprestado", descriptionCondition: "1 semana, mas a gente conversa.", constraintIconWidth: 16.0, constraintIconHeight: 16.0), (iconCondition: #imageLiteral(resourceName: "local-icon"), titleCondition: "Local de retirada", descriptionCondition: "Qualquer lugar em Brasília.", constraintIconWidth: 15.0, constraintIconHeight: 18.0)]
    
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.removeTabBar()
        
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
    
    func configureKeyboardNotifications(){
        let hideKeyboardBlock = {
            UIView.animate(
                withDuration: 0.25,
                delay: 0.0,
                options: UIViewAnimationOptions(),
                animations: {
                    () -> Void in
                    self.container?.frame = CGRect(x: self.container!.frame.origin.x, y: 335, width: self.container!.frame.width, height: self.container!.frame.height)
            },
                completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            hideKeyboardBlock()
        }
    
        let showKeyboardBlock = { (notification: Notification) in
            if let  obj = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] {
                self.keyboardFrameSize = CGRect.null
                
                if (obj as AnyObject).responds(to: #selector(NSValue.getValue(_:))) {
                    (obj as AnyObject).getValue(&self.keyboardFrameSize)
                    
                    UIView.animate(
                        withDuration: 0.25,
                        delay: 0.0,
                        options: UIViewAnimationOptions(),
                        animations: {
                            () -> Void in
                            self.container?.frame = CGRect(x: self.container!.frame.origin.x, y: 75, width: self.container!.frame.width, height:  self.container!.frame.width)
                    },
                        completion: nil)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            
            showKeyboardBlock(notification)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        UIView *view = [[UIView alloc] initWithFrame:kInitialViewFrame];
//        [view setBackgroundColor:[UIColor whiteColor]];
//        
//        UIView *container = [self container];
//        [container addSubview:[self textView]];
//        [container addSubview:[self composeBarView]];
//        [view addSubview:container];
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//        
//        [self setView:view];
        
        
     //   initializeContainer()
       // initializeComposeBar()
        //container?.addSubview(composeBarView!)
        registerNibs()
        configureTableView()
       // configureKeyboardNotifications()
        //self.view.addSubview(container!)
    }
    
    func initializeContainer() {
        container = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height-40, width: 320.0, height: 30.0))
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func initializeComposeBar(){
        
        composeBarView = PHFComposeBarView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: PHFComposeBarViewInitialHeight))
        composeBarView?.maxCharCount = 160
        composeBarView?.maxLinesCount = 5
        composeBarView?.placeholder = "place holder"
        composeBarView?.textView.accessibilityIdentifier = "Input"
        composeBarView?.placeholderLabel.accessibilityIdentifier = "Placeholder"
        
        composeBarView?.buttonTitle = "Enviar"
        composeBarView?.backgroundColor = UIColor.red
        composeBarView?.utilityButton.accessibilityIdentifier = "Utility"
        
        //composeBarView?.button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        //composeBarView?.button.frame = CGRect(x: 313, y: 10, width: 53, height: 26)
        
        
        
//        some : (313.0, 10.0, 62.0, 26.0)
//        ▿ origin : (313.0, 10.0)
//        - x : 313.0
//        - y : 10.0
//        ▿ size : (62.0, 26.0)
//        - width : 62.0
//        - height : 26.0
        //rame = (267 10; 53 26)
//        _composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
//        [_composeBarView setMaxCharCount:160];
//        [_composeBarView setMaxLinesCount:5];
//        [_composeBarView setPlaceholder:@"Type something..."];
//        //    [_composeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
//        [_composeBarView setDelegate:self];
//        [[_composeBarView placeholderLabel] setAccessibilityIdentifier:@"Placeholder"];
//        [[_composeBarView textView] setAccessibilityIdentifier:@"Input"];
//        //[[_composeBarView button] setAccessibilityIdentifier:@"Submit"];
//        [[_composeBarView utilityButton] setAccessibilityIdentifier:@"Utility"];
//        
    }
    
    func selectorTest(_ sender: UIButton) {
        
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
        
        cell.cellData = inputFieldsCondition[indexPath.row-4]
        
        return cell
    }
    
    func generateUserCommentCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCommentTableViewCell.identifier, for: indexPath) as! UserCommentTableViewCell
        
        //cell.comment = self.allComments[indexPath.row-5]
        
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
        case 3:
            return generateTextFieldCell(tableView, cellForRowAt: indexPath)
        case 4..<inputFieldsCondition.count+4:
            return generateConditionCell(tableView, cellForRowAt: indexPath)
        case inputFieldsCondition.count+4:
            return generateUserCommentCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFieldsCondition.count+5
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

extension ThingDetailViewController: UpdateCellHeightDelegate {
    func updateCellBy(height: CGFloat) {
        self.textFieldHeight = height
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
