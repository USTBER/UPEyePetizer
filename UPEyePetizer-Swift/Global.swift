//
//  Global.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/17.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation
import UIKit

//精选列表
let choiceUrlStr = "http://baobab.kaiyanapp.com/api/v4/tabs/selected"

//关注列表
let attUrlStr = "http://baobab.kaiyanapp.com/api/v4/tabs/follow"

//全部作者列表
let authorUrlStr = "http://baobab.kaiyanapp.com/api/v4/pgcs/all"

//全部分类列表
let categoryUrlStr = "http://baobab.wandoujia.com/api/v3/discovery"

//发现列表
let findTabListUrlStr = "http://baobab.kaiyanapp.com/api/v4/discovery"

//全部分类 -- 热门排行
let hotRankWeekUrlStr = "http://baobab.wandoujia.com/api/v3/ranklist?_s=70fe21a9017cd00bd7390c82ca130cd3&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&strategy=weekly&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"

let hotRankMonthUrlStr = "http://baobab.wandoujia.com/api/v3/ranklist?_s=ad3563d12d394bbe78b043315f670c2c&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&strategy=monthly&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"

let hotRankAllUrlStr = "http://baobab.wandoujia.com/api/v3/ranklist?_s=d338bb73d852e2ede36ae280f8189e25&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&strategy=historical&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"

//全部分类 -- 热门专题
let chooseHotUrlStr = "http://baobab.wandoujia.com/api/v3/specialTopics?_s=44e4ee05b1f5d1efd3e30735e81230b2"
//热门专题详情页
let hotStrOne = "http://baobab.wandoujia.com/api/v3/lightTopics/"
let hotStrTwo = "?_s=a79330319730972fbf185bd61e331e04&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"



let screenW: CGFloat = UIScreen.main.bounds.width
let screenH: CGFloat = UIScreen.main.bounds.height

//精选：videlCell的高度
let choiCellH: CGFloat = heightFromWidth(width: UIScreen.main.bounds.width)

//关注: 信息Bar高度
let briedAndScrollCardBarH: CGFloat = 64

func heightFromWidth(width: CGFloat) -> CGFloat {
    
    return (width * 164) / 320
}


