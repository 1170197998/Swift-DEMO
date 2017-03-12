//
//  ViewController.swift
//  ScreenRotation
//
//  Created by ShaoFeng on 12/03/2017.
//  Copyright © 2017 ShaoFeng. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    var label: UILabel! = nil
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel()
        label.text = "横竖屏自适应DEMO"
        label.sizeToFit()
        label.textAlignment = .center
        label.backgroundColor = UIColor.gray
        view.addSubview(label)
        
        label.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(label.snp.width).multipliedBy(9.0 / 16.0)
        })
        
        addNotifications()
    }
    
    /// 添加通知
    private func addNotifications() {
        // 检测设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // 检测状态栏方向
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    /// 设备方向改变
    @objc fileprivate func deviceOrientationChange() {
        // 获取当前设备方向
        let orientation = UIDevice.current.orientation
        // 如果手机硬件屏幕朝上或者屏幕朝下或者未知
        if orientation == UIDeviceOrientation.faceUp || orientation == UIDeviceOrientation.faceDown || orientation == UIDeviceOrientation.unknown {
            return
        }
        let interfaceOrientation: UIInterfaceOrientation = UIInterfaceOrientation(rawValue: orientation.rawValue)!
        switch interfaceOrientation {
        //屏幕竖直,home键在上面
        case UIInterfaceOrientation.portraitUpsideDown: break
        //屏幕竖直,home键在下面
        case UIInterfaceOrientation.portrait:
                toOrientation(orientation: UIInterfaceOrientation.portrait); break
        //屏幕水平,home键在左
        case UIInterfaceOrientation.landscapeLeft:
            toOrientation(orientation: UIInterfaceOrientation.landscapeLeft); break
        //屏幕水平,home键在右
        case UIInterfaceOrientation.landscapeRight:
                toOrientation(orientation: UIInterfaceOrientation.landscapeRight); break
        default:
            break
        }
    }
    
    /// 状态栏方向改变
    @objc fileprivate func statusBarOrientationChange() {
        //获取当前状态栏方向
        let currentOrientation = UIApplication.shared.statusBarOrientation
        if currentOrientation == UIInterfaceOrientation.portrait {
            toOrientation(orientation: UIInterfaceOrientation.portrait)
        } else if currentOrientation == UIInterfaceOrientation.landscapeRight{
            toOrientation(orientation: UIInterfaceOrientation.landscapeRight)
        } else if currentOrientation == UIInterfaceOrientation.landscapeLeft {
            toOrientation(orientation: UIInterfaceOrientation.landscapeLeft)
        }
    }

    /// 旋转
    ///
    /// - Parameter orientation: 要旋转的方向
    private func toOrientation(orientation: UIInterfaceOrientation) {
        
        //获取当前状态栏的方向
        let currentOrientation = UIApplication.shared.statusBarOrientation
        //如果当前的方向和要旋转的方向一致,直接return
        if currentOrientation == orientation {
            return
        }
        //根据要旋转的方向,用snapKit重新布局
        if orientation != UIInterfaceOrientation.portrait {
            // 从全屏的一侧直接到全屏的另一侧不修改
            if currentOrientation == UIInterfaceOrientation.portrait {
                label.removeFromSuperview()
                label.snp.makeConstraints({ (make) in
                    make.width.equalTo(UIScreen.main.bounds.size.height)
                    make.height.equalTo(UIScreen.main.bounds.size.width)
                    make.center.equalTo(UIApplication.shared.keyWindow!)
                })
            }
        }
        //状态栏旋转
        UIApplication.shared.setStatusBarOrientation(orientation, animated: false)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.35)
        label.transform = CGAffineTransform.identity
        label.transform = getTransformRotationAngle()
        UIView.commitAnimations()
    }
    
    /// 获取旋转角度
    private func getTransformRotationAngle() -> CGAffineTransform {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        if interfaceOrientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        } else if interfaceOrientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle: (CGFloat)(-M_PI_2))
        } else if (interfaceOrientation == UIInterfaceOrientation.landscapeRight) {
            return CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        }
        return CGAffineTransform.identity
    }
}
