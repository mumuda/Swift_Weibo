//
//  NSDate+Category.swift
//  weibo
//
//  Created by ldj on 16/6/30.
//  Copyright © 2016年 ldj. All rights reserved.
//

import Foundation

extension NSDate
{
    class func sinaDate(string:String) -> NSDate {
        // 1.获取微博的创建时间
        // 1.1创建格式化对象
        let formatter = NSDateFormatter()
        
        //1.2指定时间格式
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        // 地区一定要制定，否则真迹运行会有问题，统一用en即可
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        // 1.3将字符串（nsstring）转成时间对象（nsdate）
        // 过滤掉时区的日期
        return formatter.dateFromString(string)!
        
    }
    
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var dateDesctiption: String{
        // 日历类，提供了非常丰富的日期转换函数
        // 1. 获得日历
        let cal = NSCalendar.currentCalendar()
        
        // 2. 判断是否是今天
        if cal.isDateInToday(self)
        {
            // 使用日期和当前的系统时间进行比较，判断相差的秒数
            let delta =  Int(NSDate().timeIntervalSinceDate(self))
            
            // 1分钟以内
            if delta < 60
            {
                return "刚刚"
            }
            
            // 一小时以内
            if delta < 60 * 60
            {
                return "\(delta/60)分钟前"
            }
            
            // 当天
            return "\(delta/(60 * 60))小时前"
            
        }
        
        // 日期格式字符串
        var fmtString = " HH:mm"

        // 3.判断是否是昨天
        if cal.isDateInYesterday(self)
        {
            fmtString = "昨天" + fmtString
        }else
        {
            // 不是昨天
            fmtString = "MM-dd" + fmtString
            
            // 4.判断年度
            let coms = cal.components(NSCalendarUnit.Year, fromDate: self,toDate: NSDate(), options: NSCalendarOptions(rawValue:0))
            if coms.year > 0
            {
                fmtString = "yyyy-" + fmtString
            }
        }
        
        // 5.创建日期格式化对象
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = fmtString
        
        // 6.格式化时间后返回
        return df.stringFromDate(self)
    }
}
