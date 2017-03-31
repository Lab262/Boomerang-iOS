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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.removeTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         TabBarController.mainTabBarController.showTabBar()

    }
    
    @IBAction func getPhoto(_ sender: Any) {
        let alertPicture = UIAlertController(title: "Selecione", message: nil, preferredStyle: .actionSheet)
        
        alertPicture.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alertPicture.addAction(UIAlertAction(title: "Tirar foto", style: .default, handler: { (action) -> Void in
            
            let image = UIImagePickerController.init()
            
            self.getPhotoWithCamera(image)
            
        }))
        
        alertPicture.addAction(UIAlertAction(title: "Selecionar foto da biblioteca", style: .default, handler: { (action) -> Void in
            
            let image = UIImagePickerController.init()
            
            self.getPhotoWithLibrary(image)
        }))

        self.present(alertPicture, animated: true, completion: nil)

    }
    
    func registerNib() {
       
         self.tableView.register(UINib(nibName: "SwitchButtonTableViewCell", bundle: nil), forCellReuseIdentifier: SwitchButtonTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "SimpleTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: SimpleTextFieldTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "DescriptionTextTableViewCell", bundle: nil), forCellReuseIdentifier: DescriptionTextTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "TypePostTableViewCell", bundle: nil), forCellReuseIdentifier: TypePostTableViewCell.cellIdentifier)
    
          self.tableView.register(UINib(nibName: "WithdrawalTableViewCell", bundle: nil), forCellReuseIdentifier: WithdrawalTableViewCell.cellIdentifier)
    
        self.tableView.register(UINib(nibName: "HeaderPostTableViewCell", bundle: nil), forCellReuseIdentifier: HeaderPostTableViewCell.cellIdentifier)
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
    
    
    func createPost () {
        
        self.view.endEditing(true)
        let post = Post()
        
        let pictureData = UIImagePNGRepresentation(bgPostImage.image!)
        let pictureFileObject = PFFile (data:pictureData!)
        
        post.author = ApplicationState.sharedInstance.currentUser
        post.title =  self.nameThing
        post.content = self.descriptionThing
        
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
        
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                  return generateNavigation(tableView, indexPath:indexPath)
            case  1:
                return generateHeadPostCell(tableView, indexPath:indexPath)
            case  2:
                switch typeVC {
                    case .donate:
                       return generateNameProducTextCell(tableView, indexPath:indexPath)
                    case .have:
                       return generateSwitchButtonCell(tableView, indexPath:indexPath)
                    case .need:
                        return generateSwitchButtonCell(tableView, indexPath:indexPath)

                }
            case 3:
                switch typeVC {
                    case .donate:
                        return generateDescriptionCell(tableView, indexPath:indexPath)
                    case .have:
                        return generateNameProducTextCell(tableView, indexPath:indexPath)
                    case .need:
                        return generateNameProducTextCell(tableView, indexPath:indexPath)
                }
            case 4:
                switch typeVC {
                case .donate:
                    return generateWithDrawalCell(tableView, indexPath:indexPath)
                case .have:
                    return generateDescriptionCell(tableView, indexPath:indexPath)
                case .need:
                    return generateDescriptionCell(tableView, indexPath:indexPath)
                }
        default:
                return UITableViewCell()
        }
    }
    
  
    
}

extension ThrowViewController: UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(200)
        }else if indexPath.row == 1 {
            return CGFloat(100)
        }else if indexPath.row == 2 {
            return CGFloat(100)
        }else if indexPath.row == 3 {
            return CGFloat(175)
        }else {
            return CGFloat(100)
        }
        
       
    }
}

extension ThrowViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        bgPostImage.image = image
        dismiss(animated: false, completion: nil)

    }
}

extension ThrowViewController: UINavigationControllerDelegate {
    
    func getPhotoWithLibrary(_ image: UIImagePickerController) {
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.delegate = self
         image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    
    
    func getPhotoWithCamera (_ image: UIImagePickerController) {
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.delegate = self
        image.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    
}

