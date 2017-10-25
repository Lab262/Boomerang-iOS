//
//  UIButtonWithPicker.swift
//  BilinEntregador
//
//  Created by Huallyd Smadi on 13/01/17.
//  Copyright © 2017 br.com.mobigag. All rights reserved.
//

import UIKit
import ImagePicker


protocol UIIButtonWithPickerDelegate {
    func didPickEditedImage(image: [UIImage])
}

class UIButtonWithPicker: UIButton {
    
    let imagePicker = ImagePickerController()
    var currentVC: UIViewController?
    var delegate: UIIButtonWithPickerDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.changePhoto()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imagePicker.allowsEditing = true
        self.currentVC = UIApplication.topViewController()
       // self.isUserInteractionEnabled = true
      
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
   
    }
    
    func changePhoto() {
       
        imagePicker.imageLimit = 3
        imagePicker.delegate = self

        self.currentVC!.present(imagePicker, animated: true, completion: nil)
    }
}

extension UIButtonWithPicker: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        self.delegate?.didPickEditedImage(image: images)
        self.currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
          self.currentVC?.dismiss(animated: true, completion: nil)
    }
  

}

extension UIButtonWithPicker: UINavigationControllerDelegate {}
