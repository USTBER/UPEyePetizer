//
//  String+Extension.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/13.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation

extension NSDate{
    
    
    func getWeekAndMon() -> (String) {
        
        return "-\(getWeek(weekNum: getTimes()[2])).\(getMonth(monthNum: getTimes()[0])).\(getTimes()[1])-"
    }
    
    
    private func getTimes() -> [Int] {
        
        var timers: [Int] = []
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        
        //timers.append(comps.year! % 2000)        // 年 ，后2位数
        timers.append(comps.month!)              // 月
        timers.append(comps.day!)                // 日
        //timers.append(comps.hour!)               // 小时
        //timers.append(comps.minute!)             // 分钟
        //timers.append(comps.second!)             // 秒
        timers.append(comps.weekday! - 1)        //星期
        
        return timers;
    }
    
    private func getWeek(weekNum: Int) -> (String) {
        
        let week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        
        return week[weekNum]
        
    }
    
    private func getMonth(monthNum: Int) -> (String) {
        
        let month = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"]
        
        return month[monthNum]
        
    }
    
}
