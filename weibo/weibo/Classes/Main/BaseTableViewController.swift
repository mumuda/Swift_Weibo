//
//  BaseTableViewController.swift
//  weibo
//
//  Created by ldj on 16/5/27.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate{
    
    // 定义一个变量，保存用户当前是否登陆
    var userLogin = UserAccount.userLogin()
    
    // 定义一个属性，保存未登陆界面
    var visitorView:VisitorView?
    
    
    override func loadView() {

        userLogin ? super.loadView(): setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    /**
     创建为登陆界面
     */
    private func setupVisitorView()
    {
        // 1.初始化未登陆界面
        let customView = VisitorView()
        customView.delegate = self
        visitorView = customView
        view = customView
        
        // 2.设置导航条未登陆按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.onLoginBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.onRegisterBtnClick))
    }
    
    // MARK: - VisitorViewDelegate
    
    func onLoginBtnClick() {
         // 弹出登陆界面
        let oauth = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauth)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func onRegisterBtnClick() {
       print( UserAccount.loadAccount())
    }
    
}
