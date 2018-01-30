//
//  Snackbar.swift
//  Snackbar
//
//  Created by Jaime Frutos Amian on 25.09.17.
//  Copyright © 2017 Jaime Frutos Amian. All rights reserved.
//

import UIKit

/**
 Position of the snackbar
 ````
 case bottom
 case top
 ````
 
 */

enum SnackBarPosition : Int {
    /// position at the bottom of the screen
    case bottom
    /// position at the top of the screen
    case top
}

class ProgressSnackBar: NSObject {
    
    /** Position of the snackbar in the window. */
    open var position : SnackBarPosition = .bottom {
        didSet {
            self.updateUI()
        }
    }
    
    /** Snackbar height size. */
    open var snackbarHeight : CGFloat = 65 {
        didSet {
            self.updateUI()
        }
    }
    
    /** Snackbar progress bar height size. */
    open var progressHeight : CGFloat = 2 {
        didSet {
            if progressHeight > self.snackbarHeight{
                self.progressHeight = 2
            }
            self.updateUI()
        }
    }
    
    /** Snackbar background color. */
    open var backgroundColor : UIColor = .darkGray {
        didSet {
            self.updateUI()
        }
    }
    
    /** Color of the message text. */
    open var textColor : UIColor = .white {
        didSet {
            if(textColor == self.backgroundColor){
                assertionFailure("The text color cannot be equal to background color")
            }
            self.updateUI()
        }
    }
    
    /** Color of the button label. */
    open var buttonColor : UIColor = UIColor(red: 0.02, green: 0.48, blue: 1.00, alpha: 1.00) {
        didSet {
            if(buttonColor == self.backgroundColor){
                assertionFailure("The button color cannot be equal to background color")
            }
            self.updateUI()
        }
    }
    
    /** Color of the button label while pressed. */
    open var buttonColorPressed : UIColor = .gray {
        didSet {
            self.updateUI()
        }
    }
    
    /** Color of the progress bar. */
    open var progressColor : UIColor = UIColor(red: 0.02, green: 0.48, blue: 1.00, alpha: 1.00) {
        didSet {
            self.updateUI()
            self.animateProgressBar(self.duration)
        }
    }
    
    /**  Color of the progress bar background.
     - Remark: You can use this to change progress bar visual completion (from 0 to 100 or from 100 to 0).
     */
    open var progressBackgroundColor : UIColor = .white {
        didSet {
            self.updateUI()
        }
    }
    
    //private variables
    private let window = UIApplication.shared.keyWindow!
    private let snackbarView = UIView(frame: .zero)
    private let progressView = UIView(frame: .zero)
    private let progressBackView = UIView(frame: .zero)
    private let tagIdentifier = 5944
    private var duration: Float = 3.0
    
    private var actionTapped: (() -> Void)? = nil
    
    private var snackBarConstraints = [NSLayoutConstraint]()
    private var snackBaPositionConstraint = NSLayoutConstraint()
    private var textConstraints = [NSLayoutConstraint]()
    private var buttonConstraints = [NSLayoutConstraint]()
    private var progressConstraints = [NSLayoutConstraint]()
    private var progressWidthConstraint = NSLayoutConstraint()
    private var progressBackConstraints = [NSLayoutConstraint]()
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    /**
     
     Show Snackbar with text and duration
      
     ## Usage Example: ##
     
     ````
        let sb = Snackbar()
        sb.showWithText("Snackbar with progress bar", duration: 3)
     ````
     
     Note: [Visit Github](http://github.com/BambooCode/ProgressSnackBar) for more information.
     
     - Parameter text: The message on the snackbar.
     
     - Parameter duration: The time be displayed.
     
     */
    open func showWithText(_ text: String, duration: Float) {
        
        self.commonInit()
        self.text.text = text
        self.button.isHidden = true
        self.updateUI()
        
        self.duration = duration
        self.showSnackBar(duration)
        self.animateProgressBar(duration)
    }
        
    /**
     Show Snackbar with text and duration and with completionBlock when user tap on button
     
     ## Usage Example: ##
     
     ````
     let sb = Snackbar()
     sb.showWithAction("Snackbar with progress bar", actionTitle: "Close", duration: 3, action: {
        print("Button tapped")
     })
     ````
     
     Note: [Visit Github](http://github.com/BambooCode/ProgressSnackBar) for more information.
     
     - Parameter text: The message on the snackbar.
     - Parameter actionTitle: The title of the button
     - Parameter duration: The time be displayed.
     - Parameter action: The callback action when user tap the button
     
     */
    open func showWithAction(_ text: String, actionTitle: String, duration: Float, action: @escaping () -> Void){
        self.actionTapped = action
        
        self.commonInit()
        self.text.text = text
        self.button.setTitle(actionTitle, for: .normal)
        self.updateUI()
        
        self.duration = duration
        self.showSnackBar(duration)
        self.animateProgressBar(duration)
    }
    
    private func existAnotherSnackBar() -> Bool{
        let count =  self.window.subviews.filter({ $0.tag == self.tagIdentifier })
         return  count.count > 0
    }
    
    private func commonInit(){
        
        if(!self.snackbarView.isDescendant(of: self.window) && !self.existAnotherSnackBar()){
            self.snackbarView.tag = self.tagIdentifier
            self.snackbarView.translatesAutoresizingMaskIntoConstraints = false
            self.progressBackView.translatesAutoresizingMaskIntoConstraints = false
            self.progressView.translatesAutoresizingMaskIntoConstraints = false
            
            self.window.addSubview(self.snackbarView)
            self.snackbarView.addSubview(self.progressBackView)
            self.snackbarView.addSubview(self.progressView)
            self.snackbarView.addSubview(self.text)
            self.snackbarView.addSubview(self.button)
        }
    }
    
    private func updateUI() {
        
        if(self.snackbarView.isDescendant(of: self.window)){
            // snackbar constraints
            self.snackBaPositionConstraint = self.position == .bottom ?
                self.snackbarView.bottomAnchor.constraint(equalTo: self.window.bottomAnchor, constant: self.snackbarHeight) :
                self.snackbarView.topAnchor.constraint(equalTo: self.window.topAnchor, constant: -self.snackbarHeight)

            self.snackbarView.removeConstraints(self.snackBarConstraints)
            self.snackBarConstraints = [
                self.snackbarView.leadingAnchor.constraint(equalTo: self.window.leadingAnchor, constant: 0),
                self.snackbarView.trailingAnchor.constraint(equalTo: self.window.trailingAnchor, constant: 0),
                self.snackbarView.heightAnchor.constraint(equalToConstant: self.snackbarHeight),
                self.snackBaPositionConstraint
            ]
            NSLayoutConstraint.activate(self.snackBarConstraints)
            
            let progressBackViewPositionContraint = self.position == .bottom ?
                self.progressBackView.topAnchor.constraint(equalTo: self.snackbarView.topAnchor, constant: 0) :
                self.progressBackView.bottomAnchor.constraint(equalTo: self.snackbarView.bottomAnchor, constant: 0)
            
            // progressBackView constraints
            self.progressBackView.removeConstraints(self.progressBackConstraints)
            self.progressBackConstraints = [
                self.progressBackView.leadingAnchor.constraint(equalTo: self.window.leadingAnchor, constant: 0),
                self.progressBackView.trailingAnchor.constraint(equalTo: self.window.trailingAnchor, constant: 0),
                self.progressBackView.heightAnchor.constraint(equalToConstant: self.progressHeight),
                progressBackViewPositionContraint
            ]
            NSLayoutConstraint.activate(self.progressBackConstraints)
            
            
            let progressViewPositionContraint = self.position == .bottom ?
                self.progressView.topAnchor.constraint(equalTo: self.snackbarView.topAnchor, constant: 0) :
                self.progressView.bottomAnchor.constraint(equalTo: self.snackbarView.bottomAnchor, constant: 0)
                
            // progressView constraints
            self.progressView.removeConstraints(self.progressConstraints)
            self.progressWidthConstraint = self.progressView.widthAnchor.constraint(equalToConstant: 0)
            self.progressConstraints = [
                self.progressView.leadingAnchor.constraint(equalTo: self.window.leadingAnchor, constant: 0),
                self.progressView.heightAnchor.constraint(equalToConstant: self.progressHeight),
                self.progressWidthConstraint,
                progressViewPositionContraint
            ]
            NSLayoutConstraint.activate(self.progressConstraints)
            
            // buttom constraints
            self.button.removeConstraints(self.buttonConstraints)
            self.buttonConstraints = [
                self.button.trailingAnchor.constraint(equalTo: self.snackbarView.trailingAnchor, constant: 0),
                self.button.widthAnchor.constraint(equalToConstant: self.button.isHidden ? 0 : self.snackbarHeight),
                self.button.heightAnchor.constraint(equalToConstant: self.snackbarHeight),
                self.button.topAnchor.constraint(equalTo: self.snackbarView.topAnchor, constant: 0)
            ]
            NSLayoutConstraint.activate(self.buttonConstraints)
            
            // text constraints
            self.text.removeConstraints(self.textConstraints)
            self.textConstraints = [
                self.text.leadingAnchor.constraint(equalTo: self.snackbarView.leadingAnchor, constant: 10),
                self.text.trailingAnchor.constraint(equalTo: self.button.leadingAnchor, constant: 10),
                self.text.heightAnchor.constraint(equalToConstant: self.snackbarHeight),
                self.text.topAnchor.constraint(equalTo: self.snackbarView.topAnchor, constant: 0)
            ]
            NSLayoutConstraint.activate(self.textConstraints)
            
            self.progressBackView.backgroundColor = self.progressColor
            self.snackbarView.backgroundColor = self.backgroundColor
            self.progressView.backgroundColor = self.progressBackgroundColor
            self.text.textColor = self.textColor
            self.button.setTitleColor(self.buttonColor,  for: .normal)
            self.button.setTitleColor(self.buttonColorPressed,  for: .selected)
            
            
            self.snackbarView.layoutSubviews()
            self.snackbarView.layoutIfNeeded()
            self.window.layoutIfNeeded()
        }
    }
    
    lazy private var text : UILabel = {
        let text = UILabel(frame: .zero)
        text.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 2
        return text
    }()
    
     lazy private var button : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(actionButtonPresed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate func showSnackBar(_ timerLength: Float){
        
        UIView.animate(withDuration: 0.4, animations: {
            
            let yPosition = self.position == .bottom ? self.window.frame.height - self.snackbarHeight : 0
            self.snackbarView.frame = CGRect(x: 0,
                                             y: yPosition,
                                             width: self.window.frame.width,
                                             height: self.snackbarHeight)
            
            Timer.scheduledTimer(timeInterval: TimeInterval(timerLength),
                                 target: self,
                                 selector: #selector(self.hideSnackBar),
                                 userInfo: nil,
                                 repeats: false)
        })
    }
    
    fileprivate func animateProgressBar(_ timerLength: Float){
        self.progressWidthConstraint.constant = self.snackbarView.frame.width
        UIView.animate(withDuration: TimeInterval(timerLength), animations: {
            self.snackbarView.layoutIfNeeded()
            
        })
    }
    
    // MARK: Selectors
    @objc private func actionButtonPresed(){
        self.actionTapped!()
        self.hideSnackBar()
    }
    
    @objc private func hideSnackBar(){
        
        UIView.animate(withDuration: 0.4, animations: {
            
            let yPosition = self.position == .bottom ? self.window.frame.height :  -self.snackbarHeight
            self.snackbarView.frame = CGRect(x: 0,
                                             y: yPosition,
                                             width: self.window.frame.width,
                                             height: self.snackbarHeight)
        }, completion: { (completed) in
            self.snackbarView.removeFromSuperview()
        })
    }
    
    @objc private func orientationDidChange(){
        self.snackbarView.frame = CGRect(x: 0,
                                         y: self.window.frame.height - self.snackbarHeight,
                                         width: self.window.frame.width,
                                         height: self.snackbarHeight)
        
    }
    
}


