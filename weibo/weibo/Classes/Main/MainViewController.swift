//
//  MainViewController.swift
//  weibo
//
//  Created by ldj on 16/5/26.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

 /**
    command +j ->定位到目录结构
    上下建选择文件夹
    按回车－>command ＋c赋值文件夹名
    command ＋n 创建文件
 */

class MainViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注意在iOS7以前，如果设置了tintColor只有文字会变，图片不会变
//        tabBar.tintColor = UIColor.orangeColor()

        // 添加子控制器
        addChildViewControllers()
        
        // 从iOS7开始就不推荐在viewDidLoad中设置frame
//        print(tabBar.subviews);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("-----------------");
//        print(tabBar.items);
        
        // 添加➕按钮
        setComposeBtn()
    }

    /**
     监听➕按钮点击，
     注意，监听按钮点击的方法不能是私有方法
     */
    func onComposeBtn(){
        print(#function)
    }
    
    
    // MARK - 内部控制方法
    private func setComposeBtn(){
        
        // 1.添加➕按钮
        tabBar.addSubview(composeBtn)
        
        // 2.调整➕按钮的位置
        let width = UIScreen.mainScreen().bounds.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0 ,y: 0,width: width,height: 49)
//        composeBtn.frame = rect
        
        /**
         移动➕按钮
         
         - parameter <Trect: 是frame的大小
         - parameter <Tdx:   是x方向偏移的大小
         - parameter <Tdy:   是y方向偏移的大小
         */
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
        
    }
    
    /**
     添加所有子控制器
     */
    private func addChildViewControllers(){
        // 1.获取json文件
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        // 2.通过文件创建Data
        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do{
                // 3.序列化json数据 －>array  MutableContainers 可变 MutableLeaves子节点可变（有bug  过时） AllowFragments：不是常规的json
                // 有可能发生异常的代码防到这里 try!强制异常，发生异常会崩溃，try  发生异常会跳到catch
                let dictArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)
                print(dictArray)
                
                // 4.遍历数组，动态创建控制器和设置数据
                for dict in dictArray as! [[String:String]]
                {
                    // 错误原因addChildViewController参数必须有值，但是字典返回的值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch
            {
                // 发生异常之后执行的代码
                print(error)
                
                // 从本地加载创建控制器
                addChildViewController("HomeTableViewController",title: "首页",imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                
                // 添加展位控制器
                addChildViewController("NullViewController", title: "", imageName: "")
                
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }else
        {
            // 从本地加载创建控制器
            addChildViewController("HomeTableViewController",title: "首页",imageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            
            // 添加展位控制器
            addChildViewController("NullViewController", title: "", imageName: "")
            
            addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }
    
    // 私有方法，都在同名空间，为了保证方法安全，加private
    /**
     初始化子控制器
     
     - parameter childViewController: 需要初始化的子控制器
     - parameter title:               子控制器的标题
     - parameter imageName:           子控制器的图片
     */
    private func addChildViewController(childViewControllerName:String,title:String,imageName:String)
    {
        // <weibo.HomeTableViewController: 0x7ff783769770>
        
        // 动态获取命名空间
        let name = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        // 0.将字符串转换成泪
        // 0.1命名空间默认情况下就是项目的名称，但是命名空间是可以修改的
        let cls:AnyClass? = NSClassFromString(name + "." +  childViewControllerName)
        
        // 0.2通过类创建对象
        // 0.2.1 将anyclass转换为指定的类型
        let vcCls = cls as! UIViewController.Type
        // 0.2.2通过class创建对象
        let vc = vcCls.init()
        
        // 1.1设置首页tabbar对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage  = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
        // 2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        // 3.将导航控制器添加到当前控制起上
        addChildViewController(nav)
    }
    
    
    // MARK - 懒加载 private可以修饰方法和属性
    private lazy var composeBtn:UIButton = {
       let btn = UIButton()
        
        // 设置前景图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)

        // 添加监听
        btn.addTarget(self, action:#selector(MainViewController.onComposeBtn), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}
