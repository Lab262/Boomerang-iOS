//
//  TransactionFilterPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionFilterPresenter: NSObject {

    fileprivate var schemes: [Scheme] = [Scheme]()
    fileprivate var scheme: Scheme = Scheme()
    fileprivate var view: ViewDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func setScheme(scheme: Scheme) {
        self.scheme = scheme
    }
    
    func getScheme() -> Scheme {
        return self.scheme
    }
    
    func setSchemes(schemes: [Scheme]) {
        self.schemes = schemes
    }
    
    func getSchemes() -> [Scheme] {
        return self.schemes
    }
    
    func getSchemesFor(postCondition: Condition) -> [Scheme] {
        let filterSchemes = filterSchemesFor(postCondition: postCondition)
        return filterSchemes
    }
    
    func filterSchemesFor(postCondition: Condition) -> [Scheme] {
        let filteredSchemes = (self.schemes.filter { scheme in
            return scheme.post?.condition == postCondition
        })
        return filteredSchemes
    }
}
