//
//  TextFieldGroupTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class TextFieldGroupTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "textFieldCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "TextFieldGroupTableViewCell"
    }
    
    var composeBarView: PHFComposeBarView?
    var container: UIView?
    var initialViewFrame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 60.0)
    
    @IBOutlet weak var textView: UITextView!
    
    func configureNotications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillToggle(_ notification: Notification){

        var duration: TimeInterval?
        var animationCurve: UIViewAnimationCurve?
        var startFrame: CGRect?
        var endFrame: CGRect?
        
        let userInfo = notification.userInfo as! [String: NSObject] as NSDictionary
        
        duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval?
        
        animationCurve = UIViewAnimationCurve(rawValue: userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! Int)
        
        startFrame = userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey) as! CGRect?
        
        endFrame =  userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! CGRect?
        
        var signCorrection = 1
        
        if startFrame!.origin.y < CGFloat(0) || startFrame!.origin.x < CGFloat(0) || endFrame!.origin.y < CGFloat(0) || endFrame!.origin.x < CGFloat(0){
            
            signCorrection = -1
            
            _ = (endFrame!.origin.x - startFrame!.origin.x) * CGFloat(signCorrection)
            
            let heightChange = (endFrame!.origin.y - startFrame!.origin.y) * CGFloat(signCorrection)
            
            let sizeChange = heightChange
            
            var newContainerFrame = self.container?.frame
            newContainerFrame?.size.height += sizeChange
            
            UIView.animate(withDuration: duration!, delay: 0, options: .curveEaseIn, animations: {
                self.container?.frame = newContainerFrame!
            }, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureNotications()
        
        let viewBounds = self.bounds
        let frame = CGRect(x: 0.0, y: viewBounds.size.height - PHFComposeBarViewInitialHeight, width: viewBounds.size.width, height: PHFComposeBarViewInitialHeight)
        
        composeBarView = PHFComposeBarView(frame: frame)
        composeBarView?.maxCharCount = 160
        composeBarView?.maxLinesCount = 5
        composeBarView?.placeholder = "Comente"
        composeBarView?.delegate = self
        
        initializeContainer()
        
        
        let container = self.container
        container?.addSubview(composeBarView!)
        
        //composeBarView?.backgroundColor = .yellow
        self.addSubview(container!)
      
    }
    
    func initializeContainer() {
        container = UIView(frame: initialViewFrame)
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func layoutSubviews() {
        
        self.composeBarView?.setY(y: 0)
        
    }


}

extension TextFieldGroupTableViewCell: PHFComposeBarViewDelegate {
    
    func composeBarViewDidPressButton(_ composeBarView: PHFComposeBarView!) {
        if composeBarView.text != "" {
            //delegate?.sendTextByField(text: composeBarView.text)
        }
        composeBarView.setText("", animated: true)
        composeBarView.resignFirstResponder()
    }
    
    func composeBarView(_ composeBarView: PHFComposeBarView!, willChangeFromFrame startFrame: CGRect, toFrame endFrame: CGRect, duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        
        let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: endFrame.size.height, right: 0.0)
        
        textView.contentInset = insets
        textView.scrollIndicatorInsets = insets
    }
}
