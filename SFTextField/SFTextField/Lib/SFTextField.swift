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
    
    override var isSecureTextEntry: Bool {
        
        didSet {
            
            let isFirstResponder = self.isFirstResponder
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
    
    fileprivate func setup() {
        
        password = ""
        weak var weakSelf = self
        beginEditingObsever = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil, queue: nil, using: { (note) in
            if (weakSelf! == note.object as! UITextField) && (weakSelf?.isSecureTextEntry)!{
                weakSelf!.text = ""
                weakSelf!.insertText(self.password!)
            }
        })
        
        endEditingObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil, queue: nil, using: { (note) in
            if weakSelf == note.object as? UITextField {
                weakSelf?.password = weakSelf?.text
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.beginEditingObsever!)
        NotificationCenter.default.removeObserver(self.endEditingObserver!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
