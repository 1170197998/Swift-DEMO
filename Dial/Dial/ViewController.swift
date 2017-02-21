//
//  ViewController.swift
//  Dial
//
//  Created by ShaoFeng on 2017/2/18.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit
import CoreTelephony
import CallKit.CXCallObserver
enum CurrentState {
    case HasConnected //接通
    case HasEnded     //挂断
    case IsOnHold     //无人接
}
class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    let callCenter = CTCallCenter()
    let callObserver = CXCallObserver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        new()
    }
    
    //iOS10
    fileprivate func new() {
        
        callObserver.setDelegate(self, queue: DispatchQueue.main)
    }
    
    //iOS10之前
    fileprivate func old() {
        callCenter.callEventHandler =  { (call: CTCall) -> Void in
            if call.callState == CTCallStateDisconnected {
                print("电话挂断")
            }
            if call.callState == CTCallStateConnected {
                print("电话接通")
            }
            if call.callState == CTCallStateIncoming {
                print("电话被中断")
            }
            if call.callState == CTCallStateDialing {
                print("电话播出")
            }
        }
    }

    @IBAction func call(_ sender: Any) {
        callPhone()
    }
    
    //根据状态进行对应操作
    fileprivate func operation(state: CurrentState) {
        if state == CurrentState.HasEnded || state == CurrentState.IsOnHold {
            callPhone()
        } else {
            //拨打成功
        }
    }
    
    //拨号
    fileprivate func callPhone() {
        if let number = textField.text?.characters.count != 0 ? textField.text : textField.placeholder{
            let callWebView = UIWebView()
            callWebView.loadRequest(URLRequest(url:URL(string: "tel:\(number)")!))
            view.addSubview(callWebView)
            UIApplication.shared.open(URL(string:number)!, options: ["":""], completionHandler: nil)
        }
    }
}

extension ViewController: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
        if call.isOutgoing {
            
            print("电话播出")
            
            if call.hasConnected {
                print("电话接通")
                operation(state: CurrentState.HasConnected)
            }
            if call.hasEnded {
                print("电话挂断")
                operation(state: CurrentState.HasEnded)
            }
            if call.isOnHold {
                print("无人接听挂断")
                operation(state: CurrentState.IsOnHold)
            }
            
        } else {
            print("error")
        }
    }
}
