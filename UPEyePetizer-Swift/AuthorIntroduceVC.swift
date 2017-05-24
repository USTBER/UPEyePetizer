//
//  AuthorIntroduceVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AuthorIntroduceVC: BaseViewController {

    
    var authorHeaderView: AuthorHeaderView?
    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44
    var authorHeadData: [String: Any]?
    
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension AuthorIntroduceVC{
    
    override func setUpNavBar() {
        super.setUpNavBar()
        
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
    }
    
    override func setUpTableView() {
        
        super.setUpTableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height, 0, 0, 0)
        childNeedRefresh = false
        //隐藏刷新控件
        for item in tableView.subviews {
            
            if item.isKind(of: HeadAndFootRefreshView.self) {
                
                item.isHidden = true
            }
        }
        tableView.rowHeight = 74
        authorHeaderView = AuthorHeaderView(frame: CGRect(x: 0, y: 0, width: screenW, height: 200))
        tableView.tableHeaderView = authorHeaderView
        let iconUrl = authorHeadData?["icon"] as? String
        authorHeaderView?.iconUrl = iconUrl
    }
}

extension AuthorIntroduceVC{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "\(indexPath.row) -----------"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return barH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let array = ["首页","全部","专辑"]
        let barView: PageScrollBarView = PageScrollBarView(frame: CGRect(x: 0, y: self.navigationBar.bounds.height, width: barW, height: barH))
        barView.btnNameArrs = array
        
        
        return barView
    }
}

