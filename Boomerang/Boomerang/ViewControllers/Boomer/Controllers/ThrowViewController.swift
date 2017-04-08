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
     let placeholder = ["Nome do Produto","Nome do Produto","Local de retirada","placeholder"]
    var fields:[String] = []
    var nameThing = String ()
    var descriptionThing = String ()
    var typeVC = PostType.have
    var titleHeader = String()
    var imagePost: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
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
       
         self.tableView.register(UINib(nibName: "SwitchButtonTableViewCell", bundle: nil), forCellReuseIdentifier: SwitchButtonTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "SimpleTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: SimpleTextFieldTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "DescriptionTextTableViewCell", bundle: nil), forCellReuseIdentifier: DescriptionTextTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "TypePostTableViewCell", bundle: nil), forCellReuseIdentifier: TypePostTableViewCell.cellIdentifier)
    
          self.tableView.register(UINib(nibName: "WithdrawalTableViewCell", bundle: nil), forCellReuseIdentifier: WithdrawalTableViewCell.cellIdentifier)
    
        self.tableView.register(UINib(nibName: "HeaderPostTableViewCell", bundle: nil), forCellReuseIdentifier: HeaderPostTableViewCell.cellIdentifier)
    
    self.tableView.register(UINib(nibName: "TextFieldWithImageTableViewCell", bundle: nil), forCellReuseIdentifier: TextFieldWithImageTableViewCell.identifier)
    
    }

    
    
    @IBAction func throwAction(_ sender: Any) {
        
        self.createPost()
    }
    
    
    func generateHeadPostCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:TypePostTableViewCell.cellIdentifier, for: indexPath) as! TypePostTableViewCell
        cell.selectionStyle = .none
        
        switch  typeVC.hashValue {
        case 0 :
            cell.imagePost.image = #imageLiteral(resourceName: "ic_need_post")
            cell.titlePost.text = titleHeader
            break
        case  1 :
            cell.imagePost.image = #imageLiteral(resourceName: "ic_have_post")
            cell.titlePost.text = titleHeader
            break
        case  2 :
            cell.imagePost.image = #imageLiteral(resourceName: "ic_donate_post")
            cell.titlePost.text = titleHeader
            break
        default:
            cell.titlePost.text = titleHeader
            cell.imagePost.image = #imageLiteral(resourceName: "ic_donate_post")
        }
        
        return cell
        
    }
    
    func generateTextFieldWithImageCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:TextFieldWithImageTableViewCell.identifier, for: indexPath) as! TextFieldWithImageTableViewCell
        cell.anexPhotoButton.delegate = self
        
        return cell
        
    }
    func generateNavigation(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HeaderPostTableViewCell.cellIdentifier, for: indexPath) as! HeaderPostTableViewCell
        cell.selectionStyle = .none
        cell.backButton.addTarget(self, action:#selector(backAction(_:)), for:.touchUpInside)
        return cell
        
    }
    
    func generateDescriptionCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTextTableViewCell.cellIdentifier, for: indexPath) as! DescriptionTextTableViewCell
        cell.selectionStyle = .none
        
        cell.handler!.completation = { (text) -> Void in
            self.descriptionThing = text
        }
        return cell
        
    }
    
    func generateSwitchButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SwitchButtonTableViewCell.cellIdentifier, for: indexPath) as! SwitchButtonTableViewCell
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    
    func generateWithDrawalCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:WithdrawalTableViewCell.cellIdentifier, for: indexPath) as! WithdrawalTableViewCell
        cell.selectionStyle = .none
        
     
        return cell
        
    }
    
    func generateNameProducTextCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.cellIdentifier, for: indexPath) as! SimpleTextFieldTableViewCell
         cell.selectionStyle = .none
        cell.textField.placeholder = "Nome do Produto"
        
        cell.handler!.completation = { (text) -> Void in
            self.nameThing = text
        }
        
        return cell
        
    }
    
    func generateSimpleTextCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.cellIdentifier, for: indexPath) as! SimpleTextFieldTableViewCell
        cell.selectionStyle = .none
        cell.textField.placeholder = placeholder[indexPath.row]
        
        cell.handler!.completation = { (text) -> Void in
           
        }
        return cell
        
    }
    
    
    func generateWithDrawTextCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.cellIdentifier, for: indexPath) as! SimpleTextFieldTableViewCell
        cell.selectionStyle = .none
        cell.textField.placeholder = placeholder[indexPath.row]
        
        cell.handler!.completation = { (text) -> Void in
            
        }
        return cell
        
    }
    
    func generateHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: HeaderPostTableViewCell.cellIdentifier) as! HeaderPostTableViewCell
      
        header.backButton.addTarget(self, action:#selector(backAction(_:)), for:.touchUpInside)
        
        if let image = imagePost {
            header.photo.image = image
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 240
    }
    
    
    func createPost () {
        
        self.view.endEditing(true)
        let post = Post()
        
        let pictureData = UIImagePNGRepresentation(bgPostImage.image!)
        let pictureFileObject = PFFile (data:pictureData!)
        
        post.author = ApplicationState.sharedInstance.currentUser
        post.title =  self.nameThing
        post.content = self.descriptionThing
        post.postType = PostType(rawValue: typeVC.rawValue)
        
        self.view.loadAnimation()
        
        let photos = PFObject(className:"Photo")
        photos["imageFile"] = pictureFileObject
        
        photos.saveInBackground(block: { (success, error) in
            if success {
                let relation = post.relation(forKey: "photos")
                
                relation.add(photos)
                
                post.saveInBackground(block: { (success, error) in
                    if success {
                        AlertUtils.showAlertError(title:"Arrmessado com sucesso", viewController:self)
                        self.view.unload()
                    }else {
                        AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
                        self.view.unload()
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
        
        switch indexPath.row {
            case  0:
                return generateHeadPostCell(tableView, indexPath:indexPath)
            case  1:
                switch typeVC {
                    case .donate:
                       return generateNameProducTextCell(tableView, indexPath:indexPath)
                    case .have:
                       return generateSwitchButtonCell(tableView, indexPath:indexPath)
                    case .need:
                        return generateSwitchButtonCell(tableView, indexPath:indexPath)

                }
            case 2:
                switch typeVC {
                    case .donate:
                        return generateDescriptionCell(tableView, indexPath:indexPath)
                    case .have:
                        return generateNameProducTextCell(tableView, indexPath:indexPath)
                    case .need:
                        return generateNameProducTextCell(tableView, indexPath:indexPath)
                }
            case 3:
                switch typeVC {
                case .donate:
                    return generateWithDrawalCell(tableView, indexPath:indexPath)
                case .have:
                    return generateDescriptionCell(tableView, indexPath:indexPath)
                case .need:
                    return generateDescriptionCell(tableView, indexPath:indexPath)
                }
            case 4:
                switch typeVC {
                    case .donate:
                        return  UITableViewCell()
                    case .have:
                        return generateTextFieldWithImageCell(tableView, indexPath:indexPath)
                    case .need:
                        return generateTextFieldWithImageCell(tableView, indexPath:indexPath)
                    
                }
            case 6:
                switch typeVC {
                case .donate:
                    return  UITableViewCell()
                case .have:
                    return generateWithDrawalCell(tableView, indexPath:indexPath)
                case .need:
                    return generateWithDrawalCell(tableView, indexPath:indexPath)
                
            }
            
        default:
                return UITableViewCell()
        }
    }
    
  
    
}

extension ThrowViewController: UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
            return CGFloat(80)
        }else if indexPath.row == 1 {
            return CGFloat(100)
        }else if indexPath.row == 2 {
            switch typeVC {
                case .donate:
                    return CGFloat(175)
                case .have:
                    return CGFloat(80)
                case .need:
                    return CGFloat(80)
            }
            
        }else if indexPath.row == 3 {
            return CGFloat(150)
        }else if indexPath.row == 4 {
            return CGFloat(250)
        }else if indexPath.row == 5 {
            return CGFloat(100)
        }else {
            return CGFloat(10)
        }
        
       
    }
}

extension ThrowViewController: UIIButtonWithPickerDelegate{
    
    
    func didPickEditedImage(image: [UIImage]){
        imagePost = image[0]
        self.tableView.reloadData()
    }

}



