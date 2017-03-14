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

    @IBOutlet weak var bgPostImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
     let placeholder = ["Nome do Produto","Valor do Emprestimo","Periodo de disponibilidade","Quantidade disponível"]
    var fields:[String] = []
    var nameThing = String ()
    var descriptionThing = String ()
    
    
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
        
        self.tableView.register(UINib(nibName: "ThrowButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ThrowButtonTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "SimpleTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: SimpleTextFieldTableViewCell.cellIdentifier)
        
        self.tableView.register(UINib(nibName: "DescriptionTextTableViewCell", bundle: nil), forCellReuseIdentifier: DescriptionTextTableViewCell.cellIdentifier)
    }
    
    func generateThrowButtonCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:ThrowButtonTableViewCell.cellIdentifier, for: indexPath) as! ThrowButtonTableViewCell
        cell.selectionStyle = .none
        cell.throwButton.addTarget(self, action: #selector(throwAction(_:)), for: .touchUpInside)
        
        
        return cell
        
    }
    
    
    @IBAction func throwAction(_ sender: Any) {
        
        self.createPost()
    }
    
    
    func generateDescriptionCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTextTableViewCell.cellIdentifier, for: indexPath) as! DescriptionTextTableViewCell
        cell.selectionStyle = .none
        
        cell.handler!.completation = { (text) -> Void in
            self.descriptionThing = text
        }
        
        
        return cell
        
    }
    
    
    func generateNameProducTextCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:SimpleTextFieldTableViewCell.cellIdentifier, for: indexPath) as! SimpleTextFieldTableViewCell
         cell.selectionStyle = .none
        cell.textField.placeholder = placeholder[indexPath.row]
        
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
            case  0:
                return generateNameProducTextCell(tableView, indexPath:indexPath)
            case 1:
                return generateSimpleTextCell(tableView, indexPath:indexPath)
            case 2:
                return generateSimpleTextCell(tableView, indexPath:indexPath)
            case 3:
                return generateSimpleTextCell(tableView, indexPath:indexPath)
            case 4:
                return generateDescriptionCell(tableView, indexPath: indexPath)
            case 5:
                return generateThrowButtonCell(tableView, indexPath: indexPath)
            default:
                return UITableViewCell()
        }
    }
    
}

extension ThrowViewController: UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4 {
            return CGFloat(180)
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

