//
//  UIImageView+ Extension.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/17.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import SDWebImage

extension UIImageView{
    
    func up_setWebImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool? = false ) -> () {
        
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
        
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _)  in 
            
            //对请求成功后的图片做进一步处理
            
            if isAvatar!{
                
                self?.image = image?.setAvatarImage(size: CGSize(width: (self?.bounds.width)!, height: (self?.bounds.height)!))
            }
        }
    }
    
}
