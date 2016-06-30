//
//  UserAccount.swift
//  weibo
//
//  Created by ldj on 16/6/14.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import SVProgressHUD
// Swift2.0打印对象需要重写CustomStringConvertible协议中的description方法
class UserAccount: NSObject ,NSCoding{

    var access_token :String?
    var expires_in :NSNumber?{
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expires_Date)
        }
    }
    
    // 保存用户过期时间
    var expires_Date:NSDate?
    
    // 当前授权用户的UID
    var uid :String?
    
    // 友好得显示的名称
    var screen_name: String?
    
    // 用户的头像（大图）180*180
    var avatar_large: String?

    init(dict: [String: AnyObject]) {
        super.init()
        // 注意如果直接赋值不会调用didSet ，如果实在初始化的时候赋值 就不会调用didSet方法
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    func loadUserInfo(finished:(account:UserAccount?,error:NSError?)->()){
        assert(access_token != nil, "没有授权")
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token!,"uid":uid!]
        
        NetWorkTools.shareNetWorkTools().GET(path, parameters: params, success: { (_, JSON) in
            // 判断字典是否有值
            if let dict = JSON as? [String:AnyObject]
            {
                self.screen_name = dict["screen_name"] as! String
                self.avatar_large = dict["avatar_large"] as! String
                // 保存用户信息
                finished(account: self, error: nil)
            }
            
            }) { (_, error) in
                finished(account: nil, error: error)
                print(error)
        }
    }
    
    // 返回用户是否登陆
    class func userLogin() -> Bool {
        return loadAccount() != nil
    }
    
    override var description: String{
        
        // 1.定义属性数组
        let properties = ["access_token","expires_in","uid","screen_name","avatar_large"]
        
        // 2.根据属性数组将属性转换为字典
        let dict = self.dictionaryWithValuesForKeys(properties)
        
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    

    static let filePath = "account.plist".cacheDir()
    
    // MARK: - 保存和读取
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /**
     加载授权模型
     */
    static var account: UserAccount?
    class func loadAccount() ->UserAccount?  {
        if account != nil {
            return account
        }
        
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        
        // 3.判断授权信息是否过期,   过期时间小于当前时间，授权过期
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return nil
        }
        
        return account
    }
    
    // MARK: - NSCoding
    // 从文件中读取数据
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
}
