//
//  HomeTableViewController.swift
//  weibo
//
//  Created by ldj on 16/5/26.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit


let HomeReuseIdentifier = "HomeReuseIdentifier"

// command ＋ optation ＋ shift ＋ 方向键  快速折叠展开～
class HomeTableViewController: BaseTableViewController {

    var statuses: [Status]?{
        didSet{
            // 当别人设置数据完毕，就刷新表格
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.如果没有登陆，就设置未登陆界面的信息
        if !userLogin {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看没有惊喜～～")
            return
        }
        
        // 初始化导航条
        setupNav()
        
        // 3.注册通知，监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: ZDPopoverAnimalWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: ZDPopoverAnimalWillDismiss, object: nil)
        
        // 注册一个cell
        tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: HomeReuseIdentifier)
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // 4.加载微博数据
        loadData()
    }
    
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func loadData(){
        Status.loadStatus { (models, error) in
            if error != nil
            {
                return
            }
            self.statuses = models
            
        }
    }
    
    /**
     修改标题按钮状态
     */
    func change(){
        //
        let titleBtn = navigationItem.titleView as! TitleButtom
        titleBtn.selected = !titleBtn.selected
    }
    
    func setupNav(){
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention",target: self,action: #selector(HomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self,action: #selector(HomeTableViewController.rightItrmClick))
        
        // 2.创建title
        let titleBtn = TitleButtom()
        titleBtn.setTitle("欢快的木木 ", forState: UIControlState.Normal)
        
        
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.onTitleBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func onTitleBtn(btn: TitleButtom){
        // 1.修改箭头方向
//        btn.selected = !btn.selected
        
        // 2.弹出尖头   定义的时候开始先用let  修改的时候改成var
        let popSB = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let popViewControl = popSB.instantiateInitialViewController()
        
        // 2.1设置谁来负责专场。专场代理
        // 默认情况下modal 会移除以前控制器的VIew ，替换为当前view
        // 如果自定义转场，那么久不会移除控制器的view
        popViewControl?.transitioningDelegate = popoverAnimal
        // 2.2设置专场的样式
        popViewControl?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popViewControl!, animated: true, completion: nil)
        
        
    }
    
    func leftItemClick(){
        print(#function)
    }
    
    func rightItrmClick(){
        let QRCodeStory = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let QRCodeVC = QRCodeStory.instantiateInitialViewController()
        presentViewController(QRCodeVC!, animated: true, completion: nil)
        
        
    }
    
    
    
    // MARK: - 懒加载
    // 一定要定义一个属性，来保存负责转场的对象，否则回保存
    
    private lazy var popoverAnimal:PopoverAnimal = {
        let pov = PopoverAnimal()
        pov.presentedFrame = CGRect(x: 100, y: 56, width: 200, height: 200)
        return pov
    }()
    
    // 缓存行高
    private var rowHeightCache = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 处理内存警告
        rowHeightCache.removeAll()
    }
    
}

extension HomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return statuses?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeReuseIdentifier, forIndexPath: indexPath) as! StatusTableViewCell
        let status = statuses![indexPath.row]
        cell.status = status
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statu = statuses![indexPath.row]
        
        if rowHeightCache[statu.id] != nil {
            print("缓存中获取")
            return rowHeightCache[statu.id]!
        }
        print("重新计算")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeReuseIdentifier) as! StatusTableViewCell
        let rowHeight = cell.rowHeight(statu)
        
        rowHeightCache[statu.id] = rowHeight
        
        return rowHeight
    }
}


