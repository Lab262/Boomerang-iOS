//
//  UIButtonWithPicker.swift
//  BilinEntregador
//
//  Created by Huallyd Smadi on 13/01/17.
//  Copyright © 2017 br.com.mobigag. All rights reserved.
//

import UIKit

protocol UIIButtonWithPickerDelegate {
    func didPickEditedImage(image: UIImage, typeFieldTag: Int)
}

class UIButtonWithPicker: UIButton {
    
    let imagePicker = UIImagePickerController()
    var currentVC: UIViewController?
    var delegate: UIIButtonWithPickerDelegate?
    
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
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

extension UIButtonWithPicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        //self.ima = image
        self.currentVC?.dismiss(animated: true, completion: nil)
        self.delegate?.didPickEditedImage(image: image, typeFieldTag: self.tag)
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

extension UIButtonWithPicker: UINavigationControllerDelegate {}
