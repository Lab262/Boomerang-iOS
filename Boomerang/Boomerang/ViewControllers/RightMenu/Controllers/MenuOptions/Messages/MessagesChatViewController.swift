//
//  MessagesChatViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class MessagesChatViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: IconNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatInputField: UITextField!
    @IBOutlet weak var containerView: UIView!
    var composeBarView: PHFComposeBarView?
    var container: UIView?
    var initialViewFrame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 60.0)
    var chatData: BoomerChatData! = BoomerChatData()
    
    @IBAction func sendMessageAction(_ sender: Any) {
        if let text = self.chatInputField.text,
            text.characters.count > 0 {
            let newMessage = MessageModel(content: text,
                                          postDateInterval: NSDate().timeIntervalSince1970,
                                          boomerSender: ApplicationState.sharedInstance.currentUser!.fullName!)
            let newRowIndexPath = IndexSet(integer: 0)
            self.chatData.messages.insert(newMessage, at: 0)
            self.tableView.reloadSections(newRowIndexPath, with: .fade)
            self.updateContentInset(for: self.tableView, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 5
        self.setupTableView()
        self.loadData()
        initializeComposeBar()
    }
    
    func initializeComposeBar() {
        
        let viewBounds = self.view.bounds
        let frame = CGRect(x: 0.0, y: viewBounds.size.height - PHFComposeBarViewInitialHeight, width: viewBounds.size.width, height: PHFComposeBarViewInitialHeight)
        
        composeBarView = PHFComposeBarView(frame: frame)
        composeBarView?.maxCharCount = 160
        composeBarView?.maxLinesCount = 5
        composeBarView?.placeholder = "Comente"
        composeBarView?.delegate = self
        
        container = UIView(frame: initialViewFrame)
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.container?.addSubview(composeBarView!)
        
        //composeBarView?.backgroundColor = .yellow
        self.view.addSubview(container!)
    }
    
    override func viewDidLayoutSubviews() {
        self.updateContentInset(for: self.tableView, animated: false)
    }
    
    func loadData() {
        
        let message1 = MessageModel(content: "Eai beleza?", postDateInterval: 50.0, boomerSender: "thiago@lab262.com")
        let message2 = MessageModel(content: "Beleza e você ?", postDateInterval: 55.0, boomerSender: "amanda@boomerang.com")
        let message3 = MessageModel(content: "Também 😀. Que dia podemos marcar de para eu ir ai te entregar a bicicleta ? Sabe se tem algum lugar ai perto para encher o pneu?", postDateInterval:72.0, boomerSender: "thiago@lab262.com")
        
        self.chatData.messages = [message1,message2,message3]
        
        
        self.updateContentInset(for: self.tableView, animated: false)
        
        
        //self.navigationBar.titleLabelText = self.chatData.friendNames?.first
        //self.navigationBar.rightBarIconImage = self.chatData.friendPhotos?.first
    }
    
    func setupTableView() {
        let nib = UINib(nibName: ChatTableViewCell.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 25
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI));
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension MessagesChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatData.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as! ChatTableViewCell
        cell.chatMessageData = self.chatData.messages[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI));
        
        return cell;
    }
    
    func updateContentInset(for tableView: UITableView, animated: Bool) {
        let lastRow = self.tableView(tableView, numberOfRowsInSection: 0)
        let lastIndex = lastRow > 0 ? lastRow - 1 : 0
        let lastIndexPath = IndexPath(item: lastIndex, section: 0)
        let lastCellFrame = self.tableView.rectForRow(at: lastIndexPath)
        let topInset: CGFloat = max(self.tableView.frame.height - lastCellFrame.origin.y - lastCellFrame.height, 0)
        var contentInset = tableView.contentInset
        contentInset.top = topInset
        let options = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animated ? 0.25 : 0.0, delay: 0.0, options: options, animations: {() -> Void in
            tableView.contentInset = contentInset
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
}

extension MessagesChatViewController {
    
    
}

extension MessagesChatViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputViewBottomConstraint.constant += keyboardSize.height
            self.updateInputViewLayout()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputViewBottomConstraint.constant -= keyboardSize.height
            self.updateInputViewLayout()
        }
    }
    
    func updateInputViewLayout() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations:{
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension MessagesChatViewController: PHFComposeBarViewDelegate {
    
    func composeBarViewDidPressButton(_ composeBarView: PHFComposeBarView!) {
        composeBarView.setText("", animated: true)
       // composeBarView.resignFirstResponder()
    }
    
    func composeBarView(_ composeBarView: PHFComposeBarView!, willChangeFromFrame startFrame: CGRect, toFrame endFrame: CGRect, duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        
       // let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: endFrame.size.height, right: 0.0)
        
     //   textView.contentInset = insets
       // textView.scrollIndicatorInsets = insets
        
        
        
        
    }
}
