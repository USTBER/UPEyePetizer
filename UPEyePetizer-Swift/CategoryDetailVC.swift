//
//  CategoryDetailVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let videoCellID = "videoCellID"

class CategoryDetailVC: BaseViewController {

    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44
    var categoryData: [String: Any]?
    var categoryFooterViewH: CGFloat = UIScreen.main.bounds.width + 10
    var categoryHeaderView: CategoryDetailHeadView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CategoryDetailVC{
    
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
        categoryHeaderView = CategoryDetailHeadView(frame: CGRect(x: 0, y: 0, width: barW, height: categoryFooterViewH))
        categoryHeaderView?.categoryData = categoryData
        tableView.tableHeaderView = categoryHeaderView
    }
}

extension CategoryDetailVC{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "\(indexPath.row) **************"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return barH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let array = ["首页","全部","作者","专辑"]
        let barView: PageScrollBarView = PageScrollBarView(frame: CGRect(x: 0, y: self.navigationBar.bounds.height, width: barW, height: barH))
        barView.btnNameArrs = array
        
        
        return barView
    }
}

extension CategoryDetailVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var contentOffsetY = scrollView.contentOffset.y
        let navBarH = navigationBar.bounds.size.height
        guard let headView = categoryHeaderView else {
            
            return
        }
        
        let bgImgView = headView.bgImgView
        contentOffsetY = contentOffsetY + navBarH
        if contentOffsetY < 0 {
            
            var rect = bgImgView.frame
            rect.origin.y = contentOffsetY
            rect.size.height = categoryFooterViewH - contentOffsetY
            bgImgView.frame = rect
        }
    }
}

