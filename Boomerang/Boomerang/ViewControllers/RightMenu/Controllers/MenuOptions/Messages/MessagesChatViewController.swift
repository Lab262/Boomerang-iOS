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

    var chatData: BoomerChatData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.loadData()
    }

    func loadData() {
        let message1 = MessageModel(content: "Eai beleza?", postDateInterval: 50.0, boomerSender: "thiago@lab262.com")
        let message2 = MessageModel(content: "Beleza e você ?", postDateInterval: 55.0, boomerSender: "amanda@boomerang.com")
        let message3 = MessageModel(content: "Também 😀. Que dia podemos marcar de para eu ir ai te entregar a bicicleta ? Sabe se tem algum lugar ai perto para encher o pneu?", postDateInterval:72.0, boomerSender: "thiago@lab262.com")
        
        self.chatData.messages = [message1,message2,message3]
        
        self.navigationBar.titleLabelText = self.chatData.friendNames?.first
        self.navigationBar.rightBarIconImage = self.chatData.friendPhotos?.first

    }
    
    func setupTableView() {
        let nib = UINib(nibName: ChatTableViewCell.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
        return cell;
    }
}
