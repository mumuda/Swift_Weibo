//
//  Status.swift
//  weibo
//
//  Created by ldj on 16/6/17.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    /// 微博创建时间
    var created_at: String?{
         didSet{
            if let time = created_at
            {
                let date = NSDate.sinaDate(time)
                created_at = date.dateDesctiption
            }
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?{
        didSet{
            // 截取字符串，// 注意: 可能为nil或者""
            // 1.获取开始截取的位置
            if let str = source
            {
                if str.isEmpty {
                    source = ""
                    return
                }
                // "<a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>"
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                
                // 1.2获取截取长度
                let length  = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                
                // 1.3截取字符串
                source = "来自："+(str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
            
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?{
        didSet{
            // 初始化数组～～
            storedPicUrlS = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] {
                    storedPicUrlS?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    
    /// 
    var storedPicUrlS:[NSURL]?
    
    /// 用户模型
    var user: UserModel?
    
    /**
     加载微博数据
     */
    class func loadStatus(finished:(models:[Status]?,error:NSError?)->()) {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        NetWorkTools.shareNetWorkTools().GET(path, parameters: params, success: { (_, JSON) in
            // 1.取出statuese key 对应的数组（存储的都是字典）
            let models = dictTwoModel(JSON!["statuses"] as! [[String: AnyObject]])
            print(models)
            
            // 缓存微博配图
            cacheStatusImages(models, finished: finished)
            
            // 2.遍历数组，将字典转换为模型

            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }
    }
    
    class func cacheStatusImages(list: [Status],finished:(models:[Status]?,error:NSError?)->()){
        
        let group = dispatch_group_create()
        
        
        for status in list {
            
            for url in status.storedPicUrlS!
            {
                // 将当前下载添加到组中
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (_, _, _, _, _) in
                    print("OK")
                    dispatch_group_leave(group)
                })
            }
            
            // 离开当前组
            dispatch_group_notify(group, dispatch_get_main_queue(), {
                // 来到这个地方，说明一定是所有图片都下载完成
                finished(models: list, error: nil)
            })
            
        }
    }
    
    /**
     将字典数据转换为模型数组
     */
    class func dictTwoModel(list:[[String: AnyObject]])->[Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        return models
    }
    
    init(dict:[String:AnyObject]!) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        // 判断 key 是否是 user，如果是 user 单独处理
        if key == "user" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                user = UserModel(dict: dict)
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properties = ["created_at","id","text","source","pic_urls"]
    
    override var description:String{
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    
    
}
