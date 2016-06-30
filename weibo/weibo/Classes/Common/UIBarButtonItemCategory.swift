//
//  UIBarButtonItemCategory.swift
//  weibo
//
//  Created by ldj on 16/5/31.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    // 如果 在func前面加上Class 就相当于OC 中的 ＋ 类方法
    class func createBarButtonItem(imageName:String,target:AnyObject?,action:Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        btn .addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)

    }
}
