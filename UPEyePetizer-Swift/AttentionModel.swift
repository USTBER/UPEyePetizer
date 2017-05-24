//
//  AttentionModel.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation

class AttentionModel: NSObject {

    var itemList: NSArray?
    var nextPageUrl: String?
    var count: Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class AttItemListModel: NSObject {
    
    var type: String?
    var data: [String : Any]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class AttDataModel: NSObject {
    
    var header: [String : Any]?
    var itemList: NSArray?
    var count: Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}


class AttDataItemListModel: NSObject {
    
    var title: String?
    var descriptionPgc: String?
    var category: String?
    var playUrl: String?
    var duration: Int = 0
    var cover: [String: Any]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
