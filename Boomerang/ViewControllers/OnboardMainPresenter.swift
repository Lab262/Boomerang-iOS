//
//  OnboardMainPresenter.swift
//  Boomerang
//
//  Created by Luís Resende on 14/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol OnboardMainDelegate {
    func reload()
}

class OnboardMainPresenter: NSObject {

    fileprivate var delegate: OnboardMainDelegate?
    
    var onboardData: [[String:Any]] = [[String:Any]]() {
        didSet {
            self.delegate?.reload()
        }
    }
    
    func setViewDelegate(delegate: OnboardMainDelegate) {
        self.delegate = delegate
    }
    
    func setOnboardData() {
        
        let firstData = setDictOnboardData(image: OnboardMainCellImages.firstCell, text: OnboardMainCellStrings.firstCell)
        let secondData = setDictOnboardData(image: OnboardMainCellImages.secondCell, text: OnboardMainCellStrings.secondCell)
        let thirdData = setDictOnboardData(image: OnboardMainCellImages.thirdCell, text: OnboardMainCellStrings.thirdCell)
        let fourthData = setDictOnboardData(image: OnboardMainCellImages.fourthCell, text: OnboardMainCellStrings.fourthCell)
        
        self.onboardData.append(contentsOf: [firstData,secondData,thirdData, fourthData])
    }
    
    private func setDictOnboardData(image: UIImage, text: String) -> [String:Any] {
        
        var dictOnboardData = [String:Any]()
        
        dictOnboardData[OnboardCellKeys.keyImageView] = image
        dictOnboardData[OnboardCellKeys.keyDescriptionLabel] = text
        
        return dictOnboardData
    }
}
