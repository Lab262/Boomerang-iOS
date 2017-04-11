//
//  ActivitIndicatorView.swift
//  laptimer
//
//  Created by Luciano Almeida on 09/01/17.
//  Copyright © 2017 AIS. All rights reserved.
//


import UIKit

protocol NVActivityIndicatorAnimationDelegate {
    func setUpAnimationInLayer(_ layer: CALayer, size: CGSize, color: UIColor)
}

public enum NVActivityIndicatorType {
    case ballScaleMultiple
    
    fileprivate func animation() -> NVActivityIndicatorAnimationDelegate {
        switch self {
        case .ballScaleMultiple:
            return NVActivityIndicatorAnimationBallScaleMultiple()
        }
    }
}

open class ActivitIndicatorView : UIView {
    fileprivate static let DEFAULT_TYPE: NVActivityIndicatorType = .ballScaleMultiple
    fileprivate static let DEFAULT_COLOR = UIColor.colorWithHexString("903a7b")
    fileprivate static let DEFAULT_SIZE: CGSize = CGSize(width: 40, height: 40)
    
    /// Animation type, value of NVActivityIndicatorType enum.
    open var type: NVActivityIndicatorType
    
    /// Color of activity indicator view.
    open var color: UIColor
    
    /// Actual size of animation in view.
    open var size: CGSize
    
    /// Current status of animation, this is not used to start or stop animation.
    open var animating: Bool = false
    
    /// Specify whether activity indicator view should hide once stopped.
    open var hidesWhenStopped: Bool = true
    
    /**
     Create a activity indicator view with default type, color and size.\n
     This is used by storyboard to initiate the view.
     
     - Default type is pacman.\n
     - Default color is white.\n
     - Default size is 40.
     
     - parameter decoder:
     
     - returns: The activity indicator view.
     */
    required public init?(coder aDecoder: NSCoder) {
        self.type = ActivitIndicatorView.DEFAULT_TYPE
        self.color = ActivitIndicatorView.DEFAULT_COLOR
        self.size = ActivitIndicatorView.DEFAULT_SIZE
        super.init(coder: aDecoder);
        super.backgroundColor = UIColor.clear
    }
    
    /**
     Create a activity indicator view with specified type, color, size and size.
     
     - parameter frame: view's frame.
     - parameter type: animation type, value of NVActivityIndicatorType enum. Default type is pacman.
     - parameter color: color of activity indicator view. Default color is white.
     - parameter size: actual size of animation in view. Default size is 40.
     
     - returns: The activity indicator view.
     */
    public init(frame: CGRect, type: NVActivityIndicatorType = DEFAULT_TYPE, color: UIColor = DEFAULT_COLOR, size: CGSize = DEFAULT_SIZE) {
        self.type = type
        self.color = color
        self.size = size
        super.init(frame: frame)
    }
    
    /**
     Start animation.
     */
    open func startAnimation() {
        if hidesWhenStopped && isHidden {
            isHidden = false
        }
        if (self.layer.sublayers == nil) {
            setUpAnimation()
        }
        self.layer.speed = 1
        self.animating = true
    }
    
    /**
     Stop animation.
     */
    open func stopAnimation() {
        self.layer.sublayers = nil
        self.animating = false
        if hidesWhenStopped && !isHidden {
            isHidden = true
        }
    }
    
    // MARK: Privates
    
    fileprivate func setUpAnimation() {
        let animation: NVActivityIndicatorAnimationDelegate = self.type.animation()
        
        self.layer.sublayers = nil
        animation.setUpAnimationInLayer(self.layer, size: self.size, color: self.color)
    }
}

class NVActivityIndicatorAnimationBallScaleMultiple: NVActivityIndicatorAnimationDelegate {
    
    func setUpAnimationInLayer(_ layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = size.width < 100 ? 1 : 2.5
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0, 0.2, 0.4]
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw balls
        for i in 0 ..< 3 {
            let circle = NVActivityIndicatorShape.circle.createLayerWith(size: size, color: color)
            let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                               y: (layer.bounds.size.height - size.height) / 2,
                               width: size.width,
                               height: size.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.opacity = 0
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
}

enum NVActivityIndicatorShape {
    case circle
    case circleSemi
    case ring
    case ringTwoHalfVertical
    case ringTwoHalfHorizontal
    case ringThirdFour
    case rectangle
    case triangle
    case line
    case pacman
    
    func createLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        switch self {
        case .circle:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * M_PI),
                        clockwise: false);
            layer.fillColor = color.cgColor
        case .circleSemi:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-M_PI / 6),
                        endAngle: CGFloat(-5 * M_PI / 6),
                        clockwise: false)
            path.close()
            layer.fillColor = color.cgColor
        case .ring:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * M_PI),
                        clockwise: false);
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfVertical:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-3 * M_PI_4),
                        endAngle:CGFloat(-M_PI_4),
                        clockwise:true)
            path.move(
                to: CGPoint(x: size.width / 2 - size.width / 2 * CGFloat(cos(M_PI_4)),
                            y: size.height / 2 + size.height / 2 * CGFloat(sin(M_PI_4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-5 * M_PI_4),
                        endAngle:CGFloat(-7 * M_PI_4),
                        clockwise:false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfHorizontal:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(3 * M_PI_4),
                        endAngle:CGFloat(5 * M_PI_4),
                        clockwise:true)
            path.move(
                to: CGPoint(x: size.width / 2 + size.width / 2 * CGFloat(cos(M_PI_4)),
                            y: size.height / 2 - size.height / 2 * CGFloat(sin(M_PI_4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-M_PI_4),
                        endAngle:CGFloat(M_PI_4),
                        clockwise:true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringThirdFour:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-3 * M_PI_4),
                        endAngle: CGFloat(-M_PI_4),
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = 2
        case .rectangle:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            layer.fillColor = color.cgColor
        case .triangle:
            let offsetY = size.height / 4
            
            path.move(to: CGPoint(x: 0, y: size.height - offsetY))
            path.addLine(to: CGPoint(x: size.width / 2, y: size.height / 2 - offsetY))
            path.addLine(to: CGPoint(x: size.width, y: size.height - offsetY))
            path.close()
            layer.fillColor = color.cgColor
        case .line:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                cornerRadius: size.width / 2)
            layer.fillColor = color.cgColor
        case .pacman:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 4,
                        startAngle: 0,
                        endAngle: CGFloat(2 * M_PI),
                        clockwise: true);
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = size.width / 2
        }
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        
        return layer
    }
}


extension ActivitIndicatorView {
    fileprivate struct AssociatedKeys {
        static var ViewName = "UIViewController+Activity+View"
    }
    
    
    public class func show(on viewController: UIViewController, overlayColor color: UIColor =  UIColor.black.withAlphaComponent(0.2), SpinnerColor spinnerColor: UIColor = UIColor.colorWithHexString("903a7b"), SpinerAlpha alpha : CGFloat = 1.0, SpinnerSize size: CGSize = CGSize(width: 88, height: 88)) {
        guard let containerView = UIApplication.shared.keyWindow else {
            return;
        }
        let view : UIView;
        if let v = objc_getAssociatedObject(viewController, &AssociatedKeys.ViewName) as? UIView {
            view = v
        } else {
            
            view = UIView()
            view.backgroundColor = color
            view.translatesAutoresizingMaskIntoConstraints = false
            
            
            let activityView = ActivitIndicatorView(frame: CGRect.zero, type: .ballScaleMultiple, color: spinnerColor, size: size)
            activityView.translatesAutoresizingMaskIntoConstraints = false
            activityView.alpha = alpha
            view.addSubview(activityView)
            
            view.addConstraint(NSLayoutConstraint(item: view,
                                                  attribute: NSLayoutAttribute.centerX,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: activityView,
                                                  attribute: NSLayoutAttribute.centerX,
                                                  multiplier: 1,
                                                  constant: 0));
            
            view.addConstraint(NSLayoutConstraint(item: view,
                                                  attribute: NSLayoutAttribute.centerY,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: activityView,
                                                  attribute: NSLayoutAttribute.centerY,
                                                  multiplier: 1,
                                                  constant: 0));
            
            activityView.startAnimation()
            //            activityView.startAnimating()
            
            objc_setAssociatedObject(viewController, &AssociatedKeys.ViewName, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        
        containerView.addSubview(view)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                    options: NSLayoutFormatOptions.alignmentMask,
                                                                    metrics: [:],
                                                                    views: ["view" : view]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                    options: NSLayoutFormatOptions.alignAllLastBaseline,
                                                                    metrics: [:],
                                                                    views: ["view" : view]))
        
        
        
    }
    
    public class func hide(on viewController: UIViewController) {
        DispatchQueue.main.async { 
            if let view = objc_getAssociatedObject(viewController, &AssociatedKeys.ViewName) as? UIView {
                view.removeFromSuperview()
            }
        }
    }
    

}
