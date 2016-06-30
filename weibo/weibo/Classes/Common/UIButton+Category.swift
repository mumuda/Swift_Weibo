//
//  UIButton+Category.swift
//  weibo
//
//  Created by ldj on 16/6/22.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

extension UIButton{
    class func createButton(imageName:String,title:String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        return btn
    }
}
