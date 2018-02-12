import UIKit

protocol PromoCodeRequestDelegate {
    func afterValidateCode()
}

class PromoCodeController: UIViewController {
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var viewCont: UIView!
    @IBOutlet weak var positiveActionLbl: UILabel!
    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var positiveButtonView: UIView!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var promoCodeTextFieldBackground: UIView!
    var isValidated = false
    var alertActionBlock: (_ isPositiveAnswer: Bool) -> Void = { ok in }
    var delegate: PromoCodeRequestDelegate?
    var keyboardHeight = CGFloat(0.0)
    var promoCodeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        self.centerYConstraint.constant = self.view.frame.size.height
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    @IBAction func selectPositiveAction(_ sender: Any) {
        self.dismissViewAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showViewAnimation()
    }
    
    @IBAction func openTermsOfService(_ sender: Any) {
        print("open terms of service")
    }
    
    @IBAction func registerPromoCode(_ sender: Any) {
        PromoCodeRequest.registerCode(code: self.promoCodeId, completionHandler: { (success, msg) in
            self.dismiss(animated: false, completion: {
                self.delegate?.afterValidateCode()
            })
        })
//        if self.isValidated {
//            PromoCodeRequest.registerCode(code: self.promoCodeId, completionHandler: { (success, msg) in
//                self.dismiss(animated: false, completion: {
//                    self.delegate?.afterValidateCode()
//                })
//            })
//        } else {
//            self.promoCodeTextField.shakeAnimation()
//        }
    }
    
    @IBAction func didChangePromoCode(_ sender: UITextField) {
        PromoCodeRequest.checkValidity(code: sender.text!, completionHandler: { (success, msg, isValid, promoCodeId) in
            self.setupValidState(isValid: isValid)
            if isValid {
                self.promoCodeId = promoCodeId
            }
        })
        print(sender.text ?? "")
    }
    
    @IBAction func askPromoCode(_ sender: Any) {
        print("ask promo code ")
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismissViewAnimation()
    }
    
    public class func presentMe(inParent vc: UIViewController, delegate: PromoCodeRequestDelegate?) {
        
        let boomerAlert = PromoCodeController()
        boomerAlert.delegate = delegate
        boomerAlert.modalPresentationStyle = .overCurrentContext
        boomerAlert.view.backgroundColor = .clear
        vc.present(boomerAlert, animated: false, completion: nil)
    }
    
    func setupValidState(isValid: Bool) {
        
        if isValid {
            self.promoCodeTextField.textColor =  UIColor.colorWithHexString("2AC148")
            self.promoCodeTextFieldBackground.borderColor = UIColor.colorWithHexString("2AC148")
        } else {
            self.promoCodeTextField.textColor = UIColor.colorWithHexString("FF4545")
            self.promoCodeTextFieldBackground.borderColor = UIColor.colorWithHexString("FF4545")
        }
        self.isValidated = isValid
    }
    
}

//Pragma MARK: - PopUp Animation
extension PromoCodeController {
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                () -> Void in
                self.centerYConstraint.constant = -100
            },
                           completion: nil)
        }
    }
    
    func showViewAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.centerYConstraint.constant = 0.0
                if self.keyboardHeight > 0 {
                    self.centerYConstraint.constant = self.keyboardHeight + self.viewCont.frame.size.height
                }
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.promoCodeTextField.becomeFirstResponder()
            })
        }) 
    }
    
    func dismissViewAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options:.curveEaseOut, animations: {
            self.centerYConstraint.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0.0
        }, completion: { (finished) in
            self.dismiss(animated: false, completion:nil)
        })
    }
}
