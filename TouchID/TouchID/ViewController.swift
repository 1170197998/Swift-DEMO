//
//  ViewController.swift
//  TouchID
//
//  Created by ShaoFeng on 2017/2/9.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testTouchID()
    }
    
    fileprivate func testTouchID() {
        
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        context.localizedFallbackTitle = "输入密码"
        
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("支持使用")
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "通过指纹验证解锁", reply: { (success, error) in
                if success {
                    print("验证成功")
                } else {
                    
                    /*
                     #define kLAErrorAuthenticationFailed           -1  授权失败
                     #define kLAErrorUserCancel                     -2  取消授权
                     #define kLAErrorUserFallback                   -3  用户选择了另一种方式,输入密码方式验证
                     #define kLAErrorSystemCancel                   -4  系统取消授权(例如其他APP切入)
                     #define kLAErrorPasscodeNotSet                 -5  系统未设置密码
                     #define kLAErrorTouchIDNotAvailable            -6  指纹不正确
                     #define kLAErrorTouchIDNotEnrolled             -7  设备Touch ID不可用，例如未打开
                     #define kLAErrorTouchIDLockout                 -8  TouchID被锁定
                     #define kLAErrorAppCancel                      -9  App取消验证
                     #define kLAErrorInvalidContext                     无效的上下文环境
                     */
                    
                    let error: NSError = error! as NSError
                    if error.code == Int(kLAErrorAuthenticationFailed) {
                        print("授权失败,三次输入错误")
                    } else if (error.code == Int(kLAErrorUserCancel)) {
                        print("用户取消")
                    } else if (error.code == Int(kLAErrorUserFallback)) {
                        print("用户选择了另一种方式,输入密码方式验证")
                    } else if (error.code == Int(kLAErrorTouchIDNotAvailable)) {
                        print("指纹不正确")
                    } else if (error.code == Int(kLAErrorTouchIDLockout)) {
                        print("Touch ID被锁定,重新锁屏再开启即可")
                    } else {
                        print("支持~出错:" + "\(error)")
                    }
                }
            })
        } else {
            print("不支持" + "\(String(describing: error))")
        }
    }
}

