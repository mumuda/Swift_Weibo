//
//  PopoverAnimal.swift
//  weibo
//
//  Created by ldj on 16/6/3.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

// 定义常量，保存通知的名称
let ZDPopoverAnimalWillShow = "ZDPopoverAnimalWillShow"
let ZDPopoverAnimalWillDismiss = "ZDPopoverAnimalWillDismiss"

class PopoverAnimal: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
 
    // 记录当前是否展开
    var isPresent:Bool = false
    
    // 定义属性，保存菜单大小
    var presentedFrame = CGRectZero
    
    // 实现代理方法，告诉系统谁来负责专场动画
    // UIPresentationController iOS8推出专门用来负责转场动画
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = PopPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentedFrame = presentedFrame
        return pc
    }
    // MARK: - 只要实现了一下方法，系统默认的动画就没有了，"所有"东西都需要程序员自己实现
    
    /**
     告诉系统谁来负责modal 的展现动画
     
     - parameter presented:  被展现实体
     - parameter presenting: 发起视图
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
         // 发送通知，通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(ZDPopoverAnimalWillShow, object: self)
        return self
    }
    
    /**
     告诉系统谁来负责modal的消失动画
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        // 发送通知，通知控制器即将消失
         NSNotificationCenter.defaultCenter().postNotificationName(ZDPopoverAnimalWillDismiss, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /**
     告诉系统如何动画，无论是动画展示或者消失，都会调用这个动画
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1.拿到展示视图
        //        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        //        let frameVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        //        print(toVC  ,  frameVC)
        
        // 通过打印发现要修改的就是toVC上面的view
        
        
        if isPresent
        {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            
            
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            transitionContext.containerView()?.addSubview(toView!)
            
            // 设置锚点
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            // 2..执行动画
            // 注意： 一定要将视图添加到容器上
            [UIView .animateWithDuration(transitionDuration(transitionContext), animations: {
                toView?.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    // 2.1执行完动画一定要告诉系统
                    // 如果不写，可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })]
        }else
        {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                // 注意： 犹豫cgfloat是不准确的，所以如果写0.0是没有动画的，
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    
}
