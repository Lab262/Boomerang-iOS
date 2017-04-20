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
    func popView()
    func showMessage(error: String)
    var photo: UIImage? {get set}
}

class EvaluationPresenter: NSObject {
    
    private var scheme: Scheme?
    private var user: User = User.current()!
    private var view: EvaluationDelegate?
    
    func setViewDelegate(view: EvaluationDelegate){
        self.view = view
    }
    
    func setScheme(scheme: Scheme) {
        self.scheme = scheme
    }
    
    func getScheme() -> Scheme {
        return self.scheme!
    }
    
    func getUser() -> User {
        return self.user
    }
    
    func createEvaluationBy(starsAmount: Int, comment: String) {
        let evaluation = Evaluation(scheme: getScheme(), comment: comment, amountStars: NSNumber(integerLiteral: starsAmount))
        evaluation.saveObjectInBackground { (success, msg) in
            if success {
                self.view?.popView()
            } else {
                self.view?.showMessage(error: msg)
            }
        }
    }
}
