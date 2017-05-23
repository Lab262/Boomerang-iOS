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
    var user: User = User.current()!
    fileprivate var view: EvaluationDelegate?
    var placeHolderText: String = EvaluationTitles.placeholder
    
    func setViewDelegate(view: EvaluationDelegate){
        self.view = view
    }
    
    func createEvaluationBy(starButtons: [UIButton], comment: String) {
        if verifyTextIsValid(text: comment) {
   
            let evaluation = Evaluation(scheme: scheme, comment: comment, amountStars: NSNumber(integerLiteral: getAmountStars(starButtons: starButtons)))
            saveEvaluation(evaluation: evaluation)
        } else {
            self.view?.showMessage(error: "Avaliação inválida! :(")
        }
    }
    
    private func getAmountStars(starButtons: [UIButton]) -> Int {
        var selectedStarButtons = [UIButton]()
        
        for starButton in starButtons where starButton.isSelected {
            selectedStarButtons.append(starButton)
        }
        
        return selectedStarButtons.count
    }
    
    private func saveEvaluation(evaluation: Evaluation) {
        
        EvaluationRequest.createEvaluation(evaluation: evaluation) { (success, msg) in
            if success {
                self.view?.presentView()
            } else {
                self.view?.showMessage(error: msg)
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
