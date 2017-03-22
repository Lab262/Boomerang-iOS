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
    
    var initialViewFrame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0)
    
    @IBOutlet weak var textView: UITextView!
    
    func configureNotications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillToggle(_ notification: Notification){
        
    
        
        
        //let keyboardFrame = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! CGRect

        var duration: TimeInterval?
        var animationCurve: UIViewAnimationCurve?
        var startFrame: CGRect?
        var endFrame: CGRect?
        
        let userInfo = notification.userInfo as! [String: NSObject] as NSDictionary
        
        duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval?
        
        //animationCurve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UIViewAnimationCurve?
        
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
        composeBarView?.placeholder = "place holder"
        composeBarView?.delegate = self
        
        let view = UIView(frame: initialViewFrame)
        view.backgroundColor = UIColor.white
        
        initializeContainer()
        
        let container = self.container
        container?.addSubview(textView)
        container?.addSubview(composeBarView!)
        self.addSubview(container!)

    }
    
    func initializeContainer() {
        container = UIView(frame: initialViewFrame)
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}

extension TextFieldGroupTableViewCell: PHFComposeBarViewDelegate {
    
}


//                
//                - (void)keyboardWillToggle:(NSNotification *)notification {
//                    NSDictionary* userInfo = [notification userInfo];
//                    NSTimeInterval duration;
//                    UIViewAnimationCurve animationCurve;
//                    CGRect startFrame;
//                    CGRect endFrame;
//                    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
//                    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]    getValue:&animationCurve];
//                    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]        getValue:&startFrame];
//                    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]          getValue:&endFrame];
//                    
//                    NSInteger signCorrection = 1;
//                    if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
//                    signCorrection = -1;
//                    
//                    CGFloat widthChange  = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
//                    CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;
//                    
//                    CGFloat sizeChange = UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ? widthChange : heightChange;
//                    
//                    CGRect newContainerFrame = [[self container] frame];
//                    newContainerFrame.size.height += sizeChange;
//                    
//                    [UIView animateWithDuration:duration
//                    delay:0
//                    options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
//                    animations:^{
//                    [[self container] setFrame:newContainerFrame];
//                    }
//                    completion:NULL];
//                    }
//                    
//                    - (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {
//                        NSString *text = [NSString stringWithFormat:@"Main button pressed. Text:\n%@", [composeBarView text]];
//                        [self prependTextToTextView:text];
//                        [composeBarView setText:@"" animated:YES];
//                        [composeBarView resignFirstResponder];
//                        }
//                        
//                        - (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView {
//                            [self prependTextToTextView:@"Utility button pressed"];
//                            }
//                            
//                            - (void)composeBarView:(PHFComposeBarView *)composeBarView
//willChangeFromFrame:(CGRect)startFrame
//toFrame:(CGRect)endFrame
//duration:(NSTimeInterval)duration
//animationCurve:(UIViewAnimationCurve)animationCurve
//{
//    [self prependTextToTextView:[NSString stringWithFormat:@"Height changing by %ld", (long)(endFrame.size.height - startFrame.size.height)]];
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, endFrame.size.height, 0.0f);
//    UITextView *textView = [self textView];
//    [textView setContentInset:insets];
//    [textView setScrollIndicatorInsets:insets];
//    }
//    
//    - (void)composeBarView:(PHFComposeBarView *)composeBarView
//didChangeFromFrame:(CGRect)startFrame
//toFrame:(CGRect)endFrame
//{
//    [self prependTextToTextView:@"Height changed"];
//    }
//    
//    - (void)prependTextToTextView:(NSString *)text {
//        NSString *newText = [text stringByAppendingFormat:@"\n\n%@", [[self textView] text]];
//        [[self textView] setText:newText];
//}
//
//@synthesize container = _container;
//- (UIView *)container {
//    if (!_container) {
//        _container = [[UIView alloc] initWithFrame:kInitialViewFrame];
//        [_container setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    }
//    
//    return _container;
//}
//
//@synthesize composeBarView = _composeBarView;
//- (PHFComposeBarView *)composeBarView {
//    if (!_composeBarView) {
//        CGRect frame = CGRectMake(0.0f,
//                                  kInitialViewFrame.size.height - PHFComposeBarViewInitialHeight,
//                                  kInitialViewFrame.size.width,
//                                  PHFComposeBarViewInitialHeight);
//        _composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
//        [_composeBarView setMaxCharCount:160];
//        [_composeBarView setMaxLinesCount:5];
//        [_composeBarView setPlaceholder:@"Type something..."];
//        [_composeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
//        [_composeBarView setDelegate:self];
//        
//        [[_composeBarView placeholderLabel] setAccessibilityIdentifier:@"Placeholder"];
//        [[_composeBarView textView] setAccessibilityIdentifier:@"Input"];
//        [[_composeBarView button] setAccessibilityIdentifier:@"Submit"];
//        [[_composeBarView utilityButton] setAccessibilityIdentifier:@"Utility"];
//    }
//    
//    return _composeBarView;
//}
//
//@synthesize textView = _textView;
//- (UITextView *)textView {
//    if (!_textView) {
//        CGRect frame = CGRectMake(0.0f,
//                                  20.0f,
//                                  kInitialViewFrame.size.width,
//                                  kInitialViewFrame.size.height - 20.0f);
//        _textView = [[UITextView alloc] initWithFrame:frame];
//        [_textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//        [_textView setEditable:NO];
//        [_textView setBackgroundColor:[UIColor clearColor]];
//        [_textView setAlwaysBounceVertical:YES];
//        [_textView setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
//        UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, PHFComposeBarViewInitialHeight, 0.0f);
//        [_textView setContentInset:insets];
//        [_textView setScrollIndicatorInsets:insets];
//        [_textView setAccessibilityIdentifier:@"Main"];
//        [_textView setText:@"Welcome to the Demo!\n\nThis is just some placeholder text to give you a better feeling of how the compose bar can be used along other components."];
//        
//        UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 480.0f, 220.0f, 60.0f)];
//        [bubbleView setBackgroundColor:[UIColor colorWithHue:206.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
//        [[bubbleView layer] setCornerRadius:25.0f];
//        [_textView addSubview:bubbleView];
//    }
//    
//    return _textView;
//}
//
