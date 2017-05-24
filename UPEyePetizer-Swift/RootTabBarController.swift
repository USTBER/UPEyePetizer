//
//  RootTabBarController.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpNewFeaOrWelViews()
        addChildViewControllers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: 添加子控制器
extension RootTabBarController{
    
    func addChildViewControllers() -> () {
        
        let dicts = [
            
            ["clsName": "ChoicenessVC", "imageName": "ic_tab_1"],
            ["clsName": "FindVC", "imageName": "ic_tab_2"],
            ["clsName": "AttentionVC", "imageName": "ic_tab_3"],
            ["clsName": "MeVC", "imageName": "ic_tab_4"]
        
        ]
        
        var arrVCs = [UIViewController]()
        for dict in dicts {
            
            let vc = addChildVC(dict: dict)
            arrVCs.append(vc)
        }
        
        viewControllers = arrVCs
        
    }
    
    private func addChildVC(dict: [String : String]) -> UIViewController {
        
        //通过反射机制获取类时，命名空间不允许出现特殊符号
        let nameSpace = Bundle.main.nameSpace
        guard let clsName = dict["clsName"],
              let cls = NSClassFromString("\(nameSpace).\(clsName)") as? UIViewController.Type,
              let imageName = dict["imageName"] else {
                
                return UIViewController()
        }
        
        let clsVc = cls.init()
        clsVc.tabBarItem.image = UIImage(named: imageName + "_49x49_")
        clsVc.tabBarItem.selectedImage = UIImage(named: imageName + "_selected_49x49_")?.withRenderingMode(.alwaysOriginal)
        clsVc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let nav = RootNavigationController(rootViewController: clsVc)
        return nav
    }
    
}

//MARK: 根据版本号设定显示新特性或欢迎界面(该界面只供测试使用)
extension RootTabBarController{

    func setUpNewFeaOrWelViews() -> () {
        
        //let showView = isNewVersion ? NewFeatureView() : WelcomeView.loadWelView()
        let showView = WelcomeView.loadWelView()
        view.addSubview(showView)
    }
    
    private var isNewVersion: Bool{
        
        let oldVersion = UserDefaults.standard.object(forKey: "versionNum") as? String ?? ""
        let curVersion = Bundle.main.versionNum
        UserDefaults.standard.setValue(curVersion, forKey: "versionNum")
        UserDefaults.standard.synchronize()
        //print("\(oldVersion) --- \(curVersion)")
        
        return oldVersion != curVersion
    }
}
