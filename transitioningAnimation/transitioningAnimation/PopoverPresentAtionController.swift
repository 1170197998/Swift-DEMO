//
//  PopoverPresentAtionController.swift
//  转场动画
//
//  Created by ShaoFeng on 16/4/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class PopoverPresentAtionController: UIPresentationController {
    
    //定义一个属性保存弹出菜单的大小
    var presrntFrame = CGRect.zero
    
    /**
     重写初始化方法,用于创建负责转场的动画
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns:
     */
    override init(presentedViewController: UIViewController, presenting: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    /**
     重写containerViewWillLayoutSubviews,在即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        
        //修改弹出视图的大小
        //presentedView: 被展现的视图
        //containerView: 容器视图
        
        if presrntFrame == CGRect.zero {
            presentedView?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        } else {
            presentedView?.frame = presrntFrame
        }
        //添加蒙版
        containerView?.insertSubview(converView, at: 0)
    }
    
    //MARK: -懒加载蒙版
    fileprivate lazy var converView: UIView = {
        
        //创建蒙版
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.frame = UIScreen.main.bounds
        
        //为蒙版view添加一个监听,点击蒙版的时候,转场消失
        let tap = UITapGestureRecognizer(target: self,action: #selector(PopoverPresentAtionController.close))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
