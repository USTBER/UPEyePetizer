//
//  ChoicenessModel.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/12.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation

class ChoicenessModel: NSObject {
    
    //var itemList: [ItemListModel]?
    
    var itemList: NSArray?
    var nextPageUrl: String?
    var count: Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class ItemListModel: NSObject {
    
    var type: String?
    var data: [String : Any]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class textHeaderDataModel: NSObject {
    
    
    var text: String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class VideoDataModel: NSObject {
    
    var title: String?
    var descriptionEditor: String?
    var category: String?
    var playUrl: String?
    var duration: Int = 0
    var cover: [String: Any]?
    var consumption: [String: Int]?
    
    var idKey: Int = 0
    
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
        if key == "id" {
            
            idKey = value as! Int
        }
    }
}

class textFooterDataModel: NSObject {
    
    
    var text: String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

class VideoCollectionDataModel: NSObject {
    
    var itemList: NSArray?
    var header: [String: AnyObject]?
    var count: Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

