//
//  PopoverAnimator.swift
//  转场动画
//
//  Created by ShaoFeng on 16/4/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

//定义常量,保存通知的名称
let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"

class PopoverAnimator: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {

    //定义一个变量,记录当前是展开状态还是消失状态
    var isPresent: Bool = false
    
    //保存弹出窗口的大小
    var presentFrame = CGRect.zero
    
    //实现代理方法,告诉系统谁来负责转场动画
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let pc = PopoverPresentAtionController(presentedViewController: presented,presenting: presenting)
        //设置菜单的大小
        pc.presrntFrame = presentFrame
        return pc
    }
    
    //只要实现了以下方法,系统默认的动画效果就没有了,需要自己实现
    //谁来负责modal的展现动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //要展现的时候调用次方法
        isPresent = true
        //要展现的时候调用的方法
        NotificationCenter.default.post(name: Notification.Name(rawValue: PopoverAnimatorWillShow), object:self)
        return self
    }
    
    //谁来负责modal的消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //要消失的时候调用次方法
        isPresent = false
        //要消失的时候调用的方法
        NotificationCenter.default.post(name: Notification.Name(rawValue: PopoverAnimatorWillDismiss), object: self)
        return self
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning协议方法
    /**
     动画时长
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    //如果动画,无论是展开还是消失,都会这个方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            
            //来到这里说明要执行展开操作
            //拿到展现视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            //把高度压缩为0
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
            
            //把视图添加容器上,
            transitionContext.containerView.addSubview(toView!)
            
            //设置锚点(由默认的中点移到上面)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            //执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                //清空transform
                toView?.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                //动画执行完毕后,一定要告诉系统
                transitionContext.completeTransition(true)
            }) 
        } else {
            
            //来到这里说明要执行关闭操作
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            //执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                //注意: 可能是因为CGFloat不准确,所以写0.0是不准确的
                //压扁(垂直方向收回去)
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000000001)
                }, completion: { (_) -> Void in
                    //告诉系统,动画执行完毕
                    transitionContext.completeTransition(true)
            })
        }
    }
}
