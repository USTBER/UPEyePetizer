//
//  AllAuthorVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/8.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let BriefCardCellID = "BriefCardCellID"
private let BriefCellID = "BriefCellID"
private let BlankCellID = "BlankCellID"

private var BriefCardCellH: CGFloat = briedAndScrollCardBarH
private var BriefCellH: CGFloat = choiCellH + 20

class AllAuthorVC: BaseViewController {

    var tableViewOriginalInsets: UIEdgeInsets?
    
    var newAuthorList = [AttItemListModel]()
    var authorList = [AttItemListModel]()
    
    var nextPageUrl: String?
    let filePath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("AuthorNewData.json")
    
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
    
    func popVC() -> () {
        
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: 请求网络数据
extension AllAuthorVC{
    
    
    func loadNewData() -> () {
        
        newAuthorList.removeAll()
        authorList.removeAll()
        
        let params = ["start": "0","num": "10"]
        loadData(URLString: authorUrlStr, parameters: params)
    }
    
    func loadMoreData() -> () {
        
        loadData(URLString: nextPageUrl!, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            if isSuccess{
                
                //将新获取的数据存入沙盒，当网络请求失败时可以使用
                if !self.isPullup {
                    
                    let JsonDic = (json as? [String: AnyObject]) ?? [:]
                    guard let data = try? JSONSerialization.data(withJSONObject: JsonDic, options: .prettyPrinted) else{
                        
                        return
                    }
                    
                    (data as NSData).write(toFile: self.filePath, atomically: true)
                }
                
                self.dicToJson(json: json!)
                
            }else {
                
                guard let dataSource = NSData(contentsOfFile: self.filePath),
                    let newJson = try? JSONSerialization.jsonObject(with: (dataSource as Data), options: .mutableContainers) as? [String: AnyObject]
                    else{
                        
                        return
                }
                
                self.dicToJson(json: newJson ?? [:])
            }
        }
    }
    
    func dicToJson(json: Any) -> () {
        
        let Authormodel = AttentionModel(dict: (json as! [String: Any]))
        nextPageUrl = Authormodel.nextPageUrl
        guard  let ItemArr = Authormodel.itemList else{
            
            return
        }
        
        for item in ItemArr {
            
            let AuthorItemModel = AttItemListModel(dict: (item as! [String : Any]))
            //if  AuthorItemModel.type == "briefCard" || AuthorItemModel.type == "videoCollectionWithBrief"{
                
                if !isPullup {
                    
                    self.newAuthorList.append(AuthorItemModel)
                }
                
                self.authorList.append(AuthorItemModel)
            //}
        
        }
        
        self.tableView.reloadData()
        self.endRefeshing()
    }
    
}

//MARK: 设置页面
extension AllAuthorVC{
    
    override func setUpNavBar() {
        
        super.setUpNavBar()
        
        let backImg = UIImage(named: "Action_close_44x44_") ?? UIImage()
        navItem.addLeftCloseBtn(backBtnImg: backImg)
        navItem.leftBtnCloseClick = {
            
            self.dismiss(animated: true, completion: nil)
        }
        navItem.title = "全部作者"
    }
    
    override func setUpTableView() {
        
        super.setUpTableView()
        
        tableView.register(AuthorBriefCardCell.self, forCellReuseIdentifier: BriefCardCellID)
        tableView.register(AuthorBriefCell.self, forCellReuseIdentifier: BriefCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BlankCellID)
        
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height, 0, 0, 0)
        tableViewOriginalInsets = tableView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

}

//MARK: 设置UITableView相关
extension AllAuthorVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isPullup ? authorList.count : newAuthorList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if authorList.count == 0{
            
            return UITableViewCell()
        }
        
        let AuthorItemModel = authorList[indexPath.row]
        switch AuthorItemModel.type! {
            
        case "briefCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCardCellID, for: indexPath) as! AuthorBriefCardCell
            let authorBriefData = AuthorItemModel.data
            cell.authorBriefData = authorBriefData
            cell.attBriefBarView.conBtnClick = {
                
                self.present(LoginVC(), animated: true, completion: nil)
            }
            return cell
            
        case "videoCollectionWithBrief":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCellID, for: indexPath) as! AuthorBriefCell
            let authorBriefDataModel = AttDataModel(dict: (AuthorItemModel.data ?? [:]))
            cell.authorBriefDataModel = authorBriefDataModel
            cell.normalView.delegate = self
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BlankCellID, for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if authorList.count == 0{
            
            return 0
        }
        
        let AuthorItemModel = authorList[indexPath.row]
        switch AuthorItemModel.type! {
            
        case "briefCard":
            
            return BriefCardCellH
            
        case "videoCollectionWithBrief":
            
            return BriefCellH
        default:
            
            return 44
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let AuthorItemModel = authorList[indexPath.row]
        let authorHeadVC = AuthorIntroduceVC()
        authorHeadVC.authorHeadData = AuthorItemModel.data
        navigationController?.pushViewController(authorHeadVC, animated: true)
    }
}

//MARK: 设置NormalScrollView代理
extension AllAuthorVC: normalScrollViewDelegate{
    
    func scrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
    
}

