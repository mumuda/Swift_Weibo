//
//  String+Category.swift
//  weibo
//
//  Created by ldj on 16/6/14.
//  Copyright © 2016年 ldj. All rights reserved.
//

import UIKit

extension String{
    
    // 将当前字符串拼接到chache目录下面
    func cacheDir()-> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    // 将当前字符串拼接到chache目录下面
    func docDir()-> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    // 将当前字符串拼接到temp目录下面
    func tmpDir()-> String{
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}