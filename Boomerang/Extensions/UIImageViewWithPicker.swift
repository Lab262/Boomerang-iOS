//
//  UIImageViewWithPicker.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 26/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol UIImageViewWithPickerDelegate {
    func didPickEditedImage(_ image: UIImage)
}

class UIImageViewWithPicker: UIImageView {
    
    let imagePicker = UIImagePickerController()
    var currentVC: UIViewController?
    var delegate: UIImageViewWithPickerDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.changePhoto()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.currentVC = UIApplication.topViewController()
        self.isUserInteractionEnabled = true
    }
    
    func changePhoto() {
        
        let pickerActionSheet = UIAlertController(title: "Fonte das imagens", message: nil, preferredStyle: .actionSheet)
        pickerActionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        pickerActionSheet.addAction(UIAlertAction(title: "Tirar foto", style: .default, handler: { (action) -> Void in
            
            self.showCameraPicker()
        }))
        pickerActionSheet.addAction(UIAlertAction(title: "Pegar da biblioteca de fotos", style: .default, handler: { (action) -> Void in
            
            self.showPhotoLibraryPicker()
        }))
        
        self.currentVC!.present(pickerActionSheet, animated: true, completion: nil)
    }
    
}


extension UIImageViewWithPicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.image = image
        self.currentVC?.dismiss(animated: true, completion: nil)
        self.delegate?.didPickEditedImage(image)
    }
    
    func showPhotoLibraryPicker() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.currentVC!.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func showCameraPicker () {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        self.currentVC!.present(self.imagePicker, animated: true, completion: nil)
    }
}

extension UIImageViewWithPicker: UINavigationControllerDelegate {}
