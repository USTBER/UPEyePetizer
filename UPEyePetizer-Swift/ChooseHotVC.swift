//
//  ChooseHotVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit
private let ImgCellID = "ImgCellID"

class ChooseHotVC: BaseViewController {

    var tableViewOriginalInsets: UIEdgeInsets?
    var nextPageUrl: String?
    var newDataList = [ItemListModel]()
    var dataList = [ItemListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadNewData()
    }
    
    override var refreshing: refreshState?{
        
        didSet{
            
            if refreshing == refreshState.StateNormal {
                
                super.superTableViewOriginalInsets = tableViewOriginalInsets
                
            }else if refreshing == refreshState.StateRefreshing{
                
                var insets = tableView.contentInset
                isPullup ? (insets.bottom = footerViewOffsetY) : (insets.top = headerViewOffserY + (tableViewOriginalInsets?.top)!)
                tableView.contentInset = insets
                isPullup ?  loadMoreData() : loadNewData()
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ChooseHotVC{
    
    
    func loadNewData() -> () {
        
        newDataList.removeAll()
        dataList.removeAll()
        loadData(URLString: chooseHotUrlStr, parameters: [:])
    }
    
    func loadMoreData() -> () {
        
        loadData(URLString: nextPageUrl!, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            if isSuccess{
            
                self.dicToJson(json: json!)
                
            }
        }
    }
    
    func dicToJson(json: Any) -> () {
        
        let chooseHotModel = ChoicenessModel(dict: (json as! [String: Any]))
        nextPageUrl = chooseHotModel.nextPageUrl
        guard  let ItemArr = chooseHotModel.itemList else{
            
            return
        }
        
        for item in ItemArr {
            
            let AttItemModel = ItemListModel(dict: (item as! [String : Any]))
            if !isPullup {
                
                self.newDataList.append(AttItemModel)
            }
            self.dataList.append(AttItemModel)
        }
        
        self.tableView.reloadData()
        self.endRefeshing()
    }

    
}

//MARK: 设置界面
extension ChooseHotVC{
    
    override func setUpNavBar() {
        super.setUpNavBar()
        
        let titleLab: UILabel = UILabel()
        titleLab.text = "专题"
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.sizeToFit()
        navItem.titleView = titleLab
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.register(UINib(nibName: "ChooseHotCell", bundle: nil), forCellReuseIdentifier: ImgCellID)
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height, 0, 0, 0)
        tableViewOriginalInsets = tableView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
        
    }

}

//MARK: 设置TableView相关
extension ChooseHotVC{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isPullup ? dataList.count : newDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ImgModel = dataList[indexPath.row]
        
        if dataList.count == 0{
            
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImgCellID, for: indexPath) as! ChooseHotCell
        cell.ImgModel = ImgModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        return choiCellH + 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemModel = dataList[indexPath.row]
        let dataModel = VideoDataModel(dict: itemModel.data ?? [:])
        
        let chooseNextVC = ChooseHotNextVC()
        chooseNextVC.hotIdKey = dataModel.idKey
        navigationController?.pushViewController(chooseNextVC, animated: true)
    }
    
}
