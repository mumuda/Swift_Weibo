//
//  UILabel+Category.swift
//  weibo
//
//  Created by ldj on 16/6/22.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

extension UILabel{
    /// 快速创建一个Label
    class func createLabel(color:UIColor, fontSize:CGFloat) -> UILabel
    {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textColor = color
        return label
    }
}
