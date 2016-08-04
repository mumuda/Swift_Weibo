//
//  StatusForwardTableViewCell.swift
//  weibo
//
//  Created by ldj on 16/7/19.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

class StatusForwardTableCell: StatusTableViewCell {

    override func setupUI() {
        super.setupUI()
        // 1.添加子控件
        insertSubview(forWardButton, belowSubview: pictureView)
        insertSubview(forWardLabel, aboveSubview: forWardButton)
        
        // 2.布局子控件
        forWardButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil,offset: CGPointMake(-10, 10))

        forWardButton.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: footView, size: nil)
        forWardLabel.text = "fdsfdsfadsfdsfdsdfsfds"
        // 布局转发正文
        forWardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forWardButton, size: nil,offset: CGPoint(x: 10, y: 10))
        
        //布局转发配图
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forWardLabel, size: CGSizeZero, offset: CGPointMake(0, 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    // MARK: - 懒加载
    private lazy var forWardLabel :UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - CGFloat(20)
        return label
    }()
    
    private lazy var forWardButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.redColor()
        return btn
    }()

}
