//
//  NetWorkTools.swift
//  weibo
//
//  Created by ldj on 16/6/14.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit
import AFNetworking

class NetWorkTools: AFHTTPSessionManager {
    
    static let tool:NetWorkTools = {
        // 注意：baseurl 一定要以／结尾
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetWorkTools(baseURL: url)
        
        // 设置afn能后接收的类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        
        return t
    }()
    
    class func shareNetWorkTools() -> NetWorkTools {
        return tool
    }
}
