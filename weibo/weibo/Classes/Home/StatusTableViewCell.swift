//
//  StatusTableViewCell.swift
//  weibo
//
//  Created by ldj on 16/6/22.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SDWebImage

let PictureViewCellIndertifier = "PictureViewCellIndertifier"


class StatusTableViewCell: UITableViewCell {
    
     /// 图片的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    
     /// 图片的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    
    var pictureTopCons:NSLayoutConstraint?
    


    var status = Status?(){
        didSet{
           // 设置顶部视图的数据
            topView.status = status
            
            contentLabel.text = status!.text
            
             pictureView.status = status
            
            // 设置配图尺寸
            // 1.1根据模型计算配图的尺寸
            let size = pictureView.calcutlateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        // 1.添加子控件
        addSubview(topView)
        addSubview(contentLabel)
        addSubview(pictureView)
        addSubview(footView)
        footView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        
        let width = UIScreen.mainScreen().bounds.size.width
        // 2.布局子控件
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSizeMake(width, 55), offset: CGPointMake(0, 10))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        footView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width,height: 44), offset: CGPoint(x: -10 , y: 10))
    }
    
    // 计算行高
    func rowHeight(status: Status) -> CGFloat{
        // 1.设置模型, 以便于调用didSet方法
        self.status = status
        
        // 2.强制更新布局
        layoutIfNeeded()
        
        // 3.返回行高
        return CGRectGetMaxY(footView.frame)
    }
    
    // MARK: - 懒加载
    
     /// 顶部视图
    lazy var topView :StatusTableViewTopView = StatusTableViewTopView()
    
    /// 正文
    lazy var contentLabel :UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - CGFloat(20)
        return label
    }()

    /// 配图
    lazy var pictureView:StatusPictureView = StatusPictureView()
    
    /// 底部视图
    lazy var footView: StatusTableViewBottomView = StatusTableViewBottomView()
    
}
