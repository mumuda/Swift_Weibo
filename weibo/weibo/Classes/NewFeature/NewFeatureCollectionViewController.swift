//
//  NewFeatureCollectionViewController.swift
//  weibo
//
//  Created by ldj on 16/6/16.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
private let reuseIdentifier = "reuseIdentifier"

class NewFeatureCollectionViewController: UICollectionViewController {
    
    // 新特性页面个数
    private let pageCount = 4
    
    // 布局流
    private var layout : UICollectionViewFlowLayout = NewFeatureLayout()
    
    // 因为系统指定的构造方法值带参数的，而不是这个不带参数的，所以不用写overred
    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.注册一个cell
        collectionView?.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        
    }
    
    // MARK: - UICollectionViewDataSource
    // 1.返回一共有多少个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    // 2.返回对应的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!  NewFeatureCell
        
        // 2.设置cell的数据
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 3.完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == (pageCount - 1) {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
            cell.startBtnAnimation()
        }
    }
}

// Swift中一个文件可以定义多个类
// 如果当前类需要监听点击方法，这个类不能是私有的
class NewFeatureCell:UICollectionViewCell
{
    // 保存图片的索引
    // Swift中被private修饰的东西，如果是在同一个文件中，是可以访问的，不同文件不能访问
    private var imageIndex: Int?{
        didSet{
            iconImage.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            startBtn.hidden = true
        }
    }
    
    /**
     让按钮动画
     */
    func startBtnAnimation(){
        startBtn.hidden = false
            // 执行动画
            startBtn.transform = CGAffineTransformMakeScale(0.0, 0.0)
            startBtn.userInteractionEnabled = false
            
            // UIViewAnimationOptions(rawValue:0), == OC knilOptions
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {
                // 清空形变
                self.startBtn.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    self.startBtn.userInteractionEnabled = true
            })
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onStartBtn(){
        // 去主页，注意点：在企业开发中如果要切换控制器，最好都在appdelegate中切换
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: true)
    }
    
    private func setupUI()
    {
        // 1.添加子空间到contentView上
        contentView.addSubview(iconImage)
        contentView.addSubview(startBtn)
        
        // 2.布局子控件的位置
        iconImage.xmg_Fill(contentView)
        startBtn.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPointMake(0, -160))
    }
    
    // MARK: - 懒加载
    private lazy var iconImage: UIImageView = UIImageView()
    
    private lazy var startBtn:UIButton = {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action:#selector(NewFeatureCell.onStartBtn), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 根据背景图片自动调整大小
        btn.sizeToFit()
        
        btn.hidden = true
        return btn
    }()
}

class NewFeatureLayout: UICollectionViewFlowLayout {
    
    // 准备布局
    // 什么时候调用 1。先调用一共有多少个cell ，2.调用准备布局 3.调用返回cell
    override func prepareLayout() {
        // 1.设置layout的布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionview的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}