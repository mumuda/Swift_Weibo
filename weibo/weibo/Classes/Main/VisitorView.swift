//
//  VisitorView.swift
//  weibo
//
//  Created by ldj on 16/5/27.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

// Swift中如何定义协议,必须遵守NSObjectProtocol协议
protocol VisitorViewDelegate: NSObjectProtocol
{
    // 登陆回调
    func onLoginBtnClick()
    
    // 注册回调
    func onRegisterBtnClick()
}
class VisitorView: UIView {

    // 定义一个属性保存代理 (弱引用) 一定要加weak 避免循环引用
    weak var delegate: VisitorViewDelegate?
    
    
    /**
     设置未登陆界面
     
     - parameter isHome:    是否是首页
     - parameter imageName: 需要展示的图标名称
     - parameter message:   需要展示的信息
     */
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String){
        // 如果不是首页隐藏转盘
        iconImgView.hidden = !isHome
        
        // 修改中间图标
        homeIconImgView.image = UIImage(named: imageName)
        
        // 修改文本
        messageLabel.text = message
        
        // 判断是否需要执行动画
        if isHome {
            startAnimation()
        }
    }
    
    func onLoginBtn()
    {
//        print(#function)
        delegate?.onLoginBtnClick()
    }
    
    func onRegisterBtn()
    {
//        print(#function)
        delegate?.onRegisterBtnClick()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加子控件
        addSubview(iconImgView)
        addSubview(maskBGImgView)  // 添加蒙板
        addSubview(homeIconImgView)
        addSubview(messageLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        // 2.布局子控件
        // 2.1设置背景 // 添加蒙板
        iconImgView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size:nil)
        maskBGImgView.xmg_Fill(self)
        // 2.2设置小房子
        homeIconImgView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        
        // 2.3设置messageLabel
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconImgView, size: nil)
        
        // "那个空间" 的 "什么属性" 等于 "另一个控件" 的 "什么属性" 乘以 "多少" 加上 "多少"
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        // 2.4设置按钮
        registerBtn.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        
        loginBtn.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        
    }
    
    // Swift推荐我们自定义一个控件，要么用纯代码，要么就用xib／Storyboard
    required init?(coder aDecoder: NSCoder) {
        // 如果通过xib／Storyboard创建该类，就会崩溃
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    private func startAnimation(){
        // 1.创建动画
        let anima = CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anima.toValue = 2 * M_PI
        anima.duration = 20
        anima.repeatCount = MAXFLOAT
        
        // 该属性默认为YES ，代表动画执行完毕就移除
        anima.removedOnCompletion = false
        
        // 3.将动画添加到图层上
        iconImgView.layer.addAnimation(anima, forKey: nil)
    }
    
    // MARK: - 懒加载控件
    /// 转盘
    private lazy var iconImgView: UIImageView = {
        let iconImgV = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iconImgV
    }()
    
    /// 图标
    private lazy var maskBGImgView: UIImageView = {
        let maImgView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return maImgView
    }()
    
    /// 图标
    private lazy var homeIconImgView: UIImageView = {
        let homeIconImgV = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return homeIconImgV
    }()
    
    /// 文本
    private lazy var messageLabel: UILabel = {
        let messLabel = UILabel()
        messLabel.numberOfLines = 0
        messLabel.textColor = UIColor.lightGrayColor()
        messLabel.textAlignment = NSTextAlignment.Center
        return messLabel
    }()
    
    /// 登陆按钮
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(VisitorView.onLoginBtn), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /// 注册按钮
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(VisitorView.onRegisterBtn), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    

}
