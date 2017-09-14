//
//  FieldCellData.swift
//  Billin
//
//  Created by Huallyd Smadi on 22/12/16.
//  Copyright © 2016 Huallyd. All rights reserved.
//

import UIKit

enum TypeField: Int {
    case registerPhotoUser = 0
    case registerName = 1
    case registerEmail = 2
    case registerPass = 3
    case registerConfirmPass = 4
    case registerPhone = 5
    case registerCpf = 6
    case registerCarName = 7
    case registerCarBrand = 8
    case registerCarPlate = 9
    case registerImgCpf = 10
    case registerImgRg = 11
    case registerImgCnh = 12
    case registerImgCrv = 13
    case registerIsAutonomous = 14
    case registerIdDistributor = 15
}

enum MaskField: Int {
    case phone = 0
    case card = 1
    case validity = 2
    case cvv = 3
    case cep = 4
    case cpf = 5
    case plate = 6
}

class FieldCellData: NSObject {
    
    var titleField: String?
    var text: String?
    var placeholder: String?
    var keyboardType: UIKeyboardType?
    var fieldMask: MaskField?
    var isSecureText: Bool?
    var dataFields: [String]?
    var typeField: TypeField?
    
    init(titleField: String? = nil, typeField: TypeField?) {
        self.titleField = titleField
        self.typeField = typeField
        
    }
    
    init(titleField: String, placeholder: String?, keyboardType: UIKeyboardType?, fieldMask: MaskField? = nil, isSecureText: Bool? = false, text: String? = nil, typeField: TypeField?) {
        self.titleField = titleField
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.fieldMask = fieldMask
        self.isSecureText = isSecureText
        self.text = text
        self.typeField = typeField
    }
    
    init(titleField: String, placeholder: String?, keyboardType: UIKeyboardType?, isSecureText: Bool? = false, dataFields: [String]?, text: String? = nil, typeField: TypeField?) {
        self.titleField = titleField
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.dataFields = dataFields
        self.isSecureText = isSecureText
        self.text = text
        self.typeField = typeField
    }
    
    
}
