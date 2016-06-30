//
//  WelcomeViewController.swift
//  weibo
//
//  Created by ldj on 16/6/17.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    private var iconBottomCons:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.初始化UI
        setupUI()
        
        // 2.设置用户信息
        if let iconUrlStr = UserAccount.loadAccount()?.avatar_large{
            let url = NSURL(string: iconUrlStr)
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 提示：修改约束不会立即生效，添加了一个标记，同意由自动布局系统更新约束
        iconBottomCons?.constant = -UIScreen.mainScreen().bounds.height - iconBottomCons!.constant
        print(-UIScreen.mainScreen().bounds.height)
        print(iconBottomCons!.constant)
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: { 
            // 强制更新约束
            self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: { 
                    self.messageLabel.alpha = 1.0
                    }, completion: { (_) in
                        // 去主页
                        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: true)
                })
        }
    }
    /**
     初始化UI
     */
    private func setupUI()
    {
        // 1.添加字控件
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2.布局子控件
        // 2.1约束背景
        bgImageView.xmg_Fill(view)
        
        //2.2约束头像
        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: view, size: CGSizeMake(100, 100), offset: CGPointMake(0, -200))
        
        // 记录底部约束
        iconBottomCons = iconView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        // 2.3约束是文字
        messageLabel.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPointMake(0, 40))
        
        
        
    }
    
    
    // MARK: - 懒加载
    // 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    // 头像
    private lazy var iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "avatar_default_big"))
        icon.layer.cornerRadius = 50
        icon.layer.masksToBounds = true
        return icon
    }()
    
    // 消息文字
    private lazy var messageLabel: UILabel = {
       let label = UILabel()
        label.text = "欢迎回来"
        label.alpha = 0.0
        label.sizeToFit()
        return label
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
