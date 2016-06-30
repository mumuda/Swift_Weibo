//
//  StatusTableViewCell.swift
//  weibo
//
//  Created by ldj on 16/6/22.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SDWebImage
class StatusTableViewCell: UITableViewCell {

    var status = Status?(){
        didSet{
            nameLabel.text = status!.user!.name
            timeLabel.text = status!.created_at
            
            contentLabel.text = status!.text
            
            // 设置用户头像
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage
            
            // 设置会员的图标
            vipView.image = status?.user?.mbrankImage
            
            // 设置来源
            sourceLabel.text = status?.source
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
    
    private func setupUI(){
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(footView)
        footView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 35,height: 35), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        // TODO：这个地方是有问题的~~~，会约束冲突
//        contentLabel.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: self, size: nil, offset: CGPoint(x: -10, y: -10))
        
        let width = UIScreen.mainScreen().bounds.width
        
        footView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width,height: 44), offset: CGPoint(x: -10 , y: 10))
        footView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: self, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))

    /// 认证图标
    private lazy var verifiedView:UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(),fontSize: 14)
    
    /// 会员图标
    private lazy var vipView:UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))

    /// 时间
    private lazy var timeLabel :UILabel = UILabel.createLabel(UIColor.darkGrayColor(),fontSize: 14)
    
    /// 来源
    private lazy var sourceLabel :UILabel = UILabel.createLabel(UIColor.darkGrayColor(),fontSize: 14)
    
    /// 正文
    private lazy var contentLabel :UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - CGFloat(20)
        return label
    }()
    
    /// 底部视图
    private lazy var footView: StatusFooterView = StatusFooterView()
}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commentBtn)
        
        // 2.布局子控件
        xmg_HorizontalTile([retweetBtn,unlikeBtn,commentBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")

    // 赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")

    // 评论
    private lazy var commentBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")

}
