//
//  NetWorkManager.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/12.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit
import AFNetworking

enum HttpMethod {
    case GET
    case POST
}

class NetWorkManager: AFHTTPSessionManager {
    
    //单例
    static let shared: NetWorkManager = {
       
        let instance = NetWorkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.requestSerializer.timeoutInterval = 4.0
        
        return instance
    }()
    
    //封装get和post请求，通过闭包回调
    func request(method: HttpMethod = .GET, URLString: String, parameters:[String: Any], completion:@escaping (_ json: Any?, _ isSuccess: Bool)->()) -> () {
        
        let success = { (task: URLSessionDataTask, json: Any) -> () in
            
            completion(json, true)
            
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            print("网络请求错误:\(error)")
            completion(nil, false)
            
        }
        
        if method == .GET {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }else{
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }
    }

}
