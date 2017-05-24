//
//  LoginVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/14.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {

    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
    }
    
    func keyboardChange(notify: Notification) -> () {
        
        guard let rect = (notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            
            return
        }
        
        print(rect)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        textPhone.resignFirstResponder()
        textPwd.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPwd() -> () {
        
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

}

extension LoginVC{
    
    override func setUpNavBar() {
        
        super.setUpNavBar()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        let backImg = UIImage(named: "Action_close_white_44x44_") ?? UIImage()
        navItem.addLeftCloseBtn(backBtnImg: backImg)
        navItem.leftBtnCloseClick = {
            
            self.dismiss(animated: true, completion: nil)
        }
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "找回密码", titleColor: UIColor.white, titleFont: 14, target: self, action: #selector(getPwd))
    }
    
    override func setUpTableView() {}
    
}
