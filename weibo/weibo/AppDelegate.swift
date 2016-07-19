//
//  AppDelegate.swift
//  weibo
//
//  Created by ldj on 16/5/26.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

// 切换控制器通知
let SwitchRootViewController = "SwitchRootViewController"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: SwitchRootViewController, object: nil)
        
        // 设置导航栏和工具栏的外观
        // 因为外观一旦设置全局有效，所以在程序一进入就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 1.创建widnow
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 2.创建根视图控制器
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        return true
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func switchRootViewController(notify:NSNotification){
        if notify.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            window?.rootViewController = WelcomeViewController()
        }
        
    }
    
    /**
     用于获取默认界面
     */
    private func defaultController()-> UIViewController{
        // 1.检查用户是否登录
        if UserAccount.userLogin()
        {
            // 判断是否有新版本
            return isNewUpdate() ? NewFeatureCollectionViewController(): WelcomeViewController()
        }
        return MainViewController()
    }

    private  func isNewUpdate() -> Bool{
        // 1.获取当前版本号 ->info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的版本号 ->从本地文件中读取（以前自己存储的）
        // 如果前面是空，就取后面的值
        let sandboxVersion = NSUserDefaults.standardUserDefaults().valueForKey("CFBundleShortVersionString") as? String ?? ""
        print("currentVersion = \(currentVersion)  sandboxVersion = \(sandboxVersion)")
        
        // 3.比较当前版本号和以前版本号
        // 3.1如果当前版本大于以前版本   有新版本
        // ios 7以后就不用调用同步方法了
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            // 3.1.1存储当前最新的版本号
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        // 3.2如果当前< ==    没有新版本
        return false
    }


}

