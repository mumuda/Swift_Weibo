//
//  PopPresentationController.swift
//  weibo
//
//  Created by ldj on 16/6/1.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

class PopPresentationController: UIPresentationController {

    // 定义属性，保存菜单大小
    var presentedFrame = CGRectZero
    
    /**
     初始化方法，用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起控制器  xcode 6是nil,xcode7是野指针
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        print(presentedViewController)
//        print(presentingViewController)
    }
    
    // 即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews()
    {
        // 1.修改弹出视图的尺寸大小
//        containerView() // 容器视图
//        presentedView() // 被展示视图
        if presentedFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else
        {
            presentedView()?.frame = presentedFrame
        }
        
        
        
        // 2.在容器视图上添加萌版，插入到展现视图的下面
        // 因为展现视图和蒙蔽都在统一视图上，后添加的会盖住先添加的
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    func close(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var coverView:UIView = {
        
        // 1.创建View
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        // 2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopPresentationController.close))
        view.addGestureRecognizer(tap)
        return view;
    }()
}
