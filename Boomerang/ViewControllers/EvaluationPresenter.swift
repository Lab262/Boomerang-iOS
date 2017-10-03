//
//  EvaluationPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol EvaluationDelegate {
    func startLoadingPhoto()
    func finishLoadingPhoto()
    func presentView()
    func showMessage(error: String)
    var photo: UIImage? {get set}
}

class EvaluationPresenter: NSObject {
    
    var scheme: Scheme!
    var profile: Profile = User.current()!.profile!
    fileprivate var view: EvaluationDelegate?
    var placeHolderText: String = EvaluationTitles.placeholder
    
    func setViewDelegate(view: EvaluationDelegate){
        self.view = view
    }

    func createEvaluationBy(starButtons: [UIButton], comment: String) {
        if verifyTextIsValid(text: comment) {
            let evaluation = Evaluation(scheme: scheme, comment: comment, evaluated: self.scheme!.dealer!, appraiser: self.profile, amountStars: NSNumber(integerLiteral: getAmountStars(starButtons: starButtons)))
            
            saveEvaluation(evaluation: evaluation)
        } else {
            self.view?.showMessage(error: "Avaliação inválida! :(")
        }
    }
    
//    func getEvaluatedOfScheme() -> Profile {
//        return self.scheme.owner == self.profile ? self.scheme.
//    }
    
    private func getAmountStars(starButtons: [UIButton]) -> Int {
        var selectedStarButtons = [UIButton]()
        
        for starButton in starButtons where starButton.isSelected {
            selectedStarButtons.append(starButton)
        }
        
        return selectedStarButtons.count
    }
    
    private func saveEvaluation(evaluation: Evaluation) {
        
        evaluation.saveInBackground { (success, error) in
            
            if let error = error {
                self.view?.showMessage(error: error.localizedDescription)
            } else {
                self.view?.presentView()
            }
        }
    }
    
    private func verifyTextIsValid(text: String) -> Bool {
        if text == "" || text == placeHolderText {
            return false
        } else {
            return true
        }
    }
}
