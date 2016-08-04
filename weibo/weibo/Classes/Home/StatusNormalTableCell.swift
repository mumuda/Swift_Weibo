//
//  StatusNormalTableCell.swift
//  weibo
//
//  Created by ldj on 16/8/4.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

class StatusNormalTableCell: StatusTableViewCell {

    override func setupUI() {
        super.setupUI()
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPointMake(0, 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)

    }

}
