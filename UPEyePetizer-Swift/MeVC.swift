//
//  MeVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class MeVC: BaseViewController {

    var backView:MeView = MeView.loadMeView()
    let arrSet: Array = ["我的消息","我的关注","我的缓存","功能开关","我要投稿","意见反馈","version - Upika"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func more() -> () {
        
        
    }
}

extension MeVC{
    
    override func setUpNavBar() {
        
        super.setUpNavBar()
        
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ICON_Menu_More_44x44_") ?? UIImage(), target: self, action: #selector(more))
        
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        backView.logAndColAndComBtnClick = {
            
            self.present(LoginVC(), animated: true, completion: nil)
        }
    }
    
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "meCell")
        childNeedRefresh = false
        headerView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(backView.frame.maxY, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        tableView.rowHeight = 94
        tableView.separatorStyle = .none
    }
}

extension MeVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "meCell", for: indexPath)
        cell.textLabel?.text = arrSet[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
        
    }
    
}
