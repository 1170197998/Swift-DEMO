//
//  SFTextField.swift
//  SFTextField
//
//  Created by ShaoFeng on 16/7/27.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class SFTextField: UITextField {
    
    var password: String?
    var beginEditingObsever: AnyObject?
    var endEditingObserver: AnyObject?
    
    override var secureTextEntry: Bool {
        
        didSet {
            
            let isFirstResponder = self.isFirstResponder()
            resignFirstResponder()
            if isFirstResponder {
                becomeFirstResponder()
            }
        }
    }
    
    /**
     
     private var _secureTextEntry = false
     override var secureTextEntry: Bool {
     
     get {
     return _secureTextEntry
     }
     
     set {
     
     let isFirstResponder = self.isFirstResponder()
     resignFirstResponder()
     self._secureTextEntry = newValue
     if isFirstResponder {
     becomeFirstResponder()
     }
     }
     }
     
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        
        password = ""
        weak var weakSelf = self
        beginEditingObsever = NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidBeginEditingNotification, object: nil, queue: nil, usingBlock: { (note) in
            if (weakSelf! == note.object as! UITextField) && (weakSelf?.secureTextEntry)!{
                weakSelf!.text = ""
                weakSelf!.insertText(self.password!)
            }
        })
        
        endEditingObserver = NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidEndEditingNotification, object: nil, queue: nil, usingBlock: { (note) in
            if weakSelf == note.object as? UITextField {
                weakSelf?.password = weakSelf?.text
            }
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self.beginEditingObsever!)
        NSNotificationCenter.defaultCenter().removeObserver(self.endEditingObserver!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
