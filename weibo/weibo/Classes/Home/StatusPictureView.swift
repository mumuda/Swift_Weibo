//
//  StatusPictureView.swift
//  weibo
//
//  Created by ldj on 16/7/19.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SDWebImage

class StatusPictureView: UICollectionView {
    var status = Status?(){
        didSet{
            sizeToFit()
            reloadData()
        }
    }
    
    private  var pictureLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init(){
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // 注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: PictureViewCellIndertifier)
        
        // 设置数据源
        dataSource = self
        
        // 2.设置cell间隙
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        // 3.设置配图的背景色
        backgroundColor = UIColor.darkGrayColor()
    }
    
    /**
     计算配图的尺寸
     */
    /*
     0.没有图片, 返回zero
     1.单张图片, 返回图片实际大小
     2.多张图片, 图片大小固定
     2.1四张图片, 会按照田字格显示
     2.2其它多图, 按照九宫格显示
     */
    func calcutlateImageSize() -> CGSize
    {
        // 获取配图个数
        let count = status?.storedPicUrlS?.count
        let itemSize = CGSizeMake(90, 90)
        let margin: CGFloat = 10
        
        pictureLayout.itemSize = itemSize
        
        // 1.没有图片, 返回zero
        if count ==  0 || count == nil{
            return CGSizeZero
        }
        
        // 2.单张图片, 返回图片实际大小
        if count == 1 {
            // 1.取出缓存图片
            let key = status?.storedPicUrlS?.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            if image == nil {
                return CGSizeZero
            }
            pictureLayout.itemSize = image.size
            return image.size
        }
        
        // 3.多张图片, 图片大小固定
        if  count == 4 {
            let viewWidth = itemSize.width * CGFloat(2) + CGFloat(margin)
            return CGSizeMake(viewWidth, viewWidth)
        }
        
        // 4.其它多图
        /*
         2,3 -> 1
         5,6 -> 2
         7,8,9 -> 3
         */
        let colCount = 3
        let rowCount = (count! - 1) / 3 + 1
        // 宽度 * 列数 + (列数 - 1) * 间隙
        let viewWidth = itemSize.width * CGFloat(colCount) + CGFloat(colCount - 1) * margin
        let viewHeight = itemSize.height * CGFloat(rowCount) + CGFloat(rowCount - 1) * margin
        
        return CGSizeMake(viewWidth, viewHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 内部类
    private class PictureViewCell: UICollectionViewCell {
        // 定义属性接受外界传入的数据
        var imageURL:NSURL?
            {
            didSet{
                iconImageView.sd_setImageWithURL(imageURL)
            }
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            //初始化UI
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI(){
            // 1.添加子控件
            contentView.addSubview(iconImageView)
            // 2.布局子控件
            iconImageView.xmg_Fill(contentView)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView:UIImageView = UIImageView()
    }
}

extension StatusPictureView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ?? 前面为nil 取后面的值
        return status?.storedPicUrlS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureViewCellIndertifier, forIndexPath: indexPath) as! PictureViewCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imageURL = status?.storedPicUrlS![indexPath.item]
        return cell
        
    }
}
