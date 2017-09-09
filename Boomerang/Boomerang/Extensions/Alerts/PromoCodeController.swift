import UIKit

class PromoCodeController: UIViewController {
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var viewCont: UIView!
    @IBOutlet weak var positiveActionLbl: UILabel!
    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var positiveButtonView: UIView!

    var alertActionBlock: (_ isPositiveAnswer: Bool) -> Void = { ok in }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerYConstraint.constant = self.view.frame.size.height
    }
    
    @IBAction func selectPositiveAction(_ sender: Any) {
        self.alertActionBlock(true)
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
        print("register promo code")
    }

    @IBAction func didChangePromoCode(_ sender: UITextField) {
        print(sender.text ?? "")
    }

    @IBAction func askPromoCode(_ sender: Any) {
        print("ask promo code ")
    }


    @IBAction func dismissView(_ sender: Any) {
        self.dismissViewAnimation()
    }

    public class func presentMe(inParent vc: UIViewController, alertActionBlock: @escaping (_ isPositiveAnswer: Bool) -> Void) {
        
        let boomerAlert = PromoCodeController()
        boomerAlert.alertActionBlock = alertActionBlock

        boomerAlert.modalPresentationStyle = .overCurrentContext
        boomerAlert.view.backgroundColor = .clear
        vc.present(boomerAlert, animated: false, completion: nil)
    }

}

//Pragma MARK: - PopUp Animation
extension PromoCodeController {
    func showViewAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.centerYConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
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
