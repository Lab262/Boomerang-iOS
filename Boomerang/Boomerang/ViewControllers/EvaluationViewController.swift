//
//  EvaluationViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EvaluationViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var evaluationTextLabel: UILabel!
    @IBOutlet weak var evaluationCommentLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    var presenter: EvaluationPresenter = EvaluationPresenter()
    var photo: UIImage? {
        didSet{
            userImage.image = photo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStarButtons()
        setupPlaceholderInTextView()
        setupKeyboardNotifications()
        setupPresenterDelegate()
        setupInformations()
        configureDynamicFont()
    }
    
    func configureDynamicFont(){
        navigationTitleLabel.setDynamicFont()
        evaluationCommentLabel.setDynamicFont()
    }
    
    func setupInformations(){
        
        var nameUser = ""
        if presenter.scheme.owner?.objectId == User.current()?.objectId {
            nameUser = (presenter.scheme.dealer?.fullName)!
            userImage.getUserImageFrom(file: (presenter.scheme.dealer?.photo!)!) { (success, msg) in
            }
        }else{
            nameUser = (presenter.scheme.owner?.fullName)!
            userImage.getUserImageFrom(file: (presenter.scheme.owner?.photo!)!) { (success, msg) in
            }
        }
        
        let textEvaluate = NSMutableAttributedString(string: EvaluationTransactionTitles.evaluateTitle, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.montserratLight(size: 16*UIView.widthScaleProportion())])
        
        let nameUserLabel = NSMutableAttributedString(string: nameUser, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.montserratBold(size: 16*UIView.widthScaleProportion())])
        
        let textEvaluateDescription = NSMutableAttributedString(string: EvaluationTransactionTitles.evaluateDescription, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.montserratLight(size: 16*UIView.widthScaleProportion())])
        
        textEvaluate.append(nameUserLabel)
        textEvaluate.append(textEvaluateDescription)
        
        self.evaluationTextLabel.attributedText = textEvaluate
    }
    
    func setupPresenterDelegate(){
        presenter.setViewDelegate(view: self)
    }
    
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupPlaceholderInTextView(){
        textView.text = presenter.placeHolderText
    }
    
    func configureStarButtons() {
        starButtons.forEach {
            $0.setImage(#imageLiteral(resourceName: "star-deselect-button"), for: .normal)
            $0.setImage(#imageLiteral(resourceName: "star_selected_button"), for: .selected)
            $0.isSelected = false
        }
    }
    
    func disableAlphaOfComponents() {
        UIView.animate(withDuration: 0.3) {
            self.evaluationCommentLabel.alpha = 1.0
            self.doneButton.alpha = 1.0
            self.textView.alpha = 1.0
        }
    }
    
    @IBAction func selectedStar(_ sender: UIButton) {
        if evaluationCommentLabel.alpha == 0.0 {
            disableAlphaOfComponents()
        }
        
        for i in (0..<starButtons.count) where i > starButtons.index(of: sender)! && starButtons[i].isSelected {
            starButtons[i].isSelected = false
        }
        
        for i in (0..<starButtons.index(of: sender)!+1) where !starButtons[i].isSelected {
            starButtons[i].isSelected = true
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        view.endEditing(true)
        presenter.createEvaluationBy(starButtons: starButtons, comment: textView.text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let  obj = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] {
            var keyboardFrame = CGRect.null
            if (obj as AnyObject).responds(to: #selector(NSValue.getValue(_:))) {
                (obj as AnyObject).getValue(&keyboardFrame)
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0.0,
                    options: UIViewAnimationOptions(),
                    animations: {
                        () -> Void in
                        self.view.frame.origin.y = -keyboardFrame.size.height
                        self.doneButton.alpha = 0.0
                },
                    completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                () -> Void in
                self.view.frame.origin.y = 0
                self.doneButton.alpha = 1.0
        },
            completion: nil)
    }
}

extension EvaluationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == presenter.placeHolderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = presenter.placeHolderText
            textView.textColor = UIColor.colorWithHexString("BFBFBF")
        }
    }
}

extension EvaluationViewController: EvaluationDelegate {
    
    func showMessage(error: String) {
        
    }
    
    func startLoadingPhoto() {
        
    }
    
    func finishLoadingPhoto() {
        
    }
    
    func presentView() {
        let viewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Main") as! TabBarController
        
        present(viewController, animated: true, completion: nil)
    }
}
