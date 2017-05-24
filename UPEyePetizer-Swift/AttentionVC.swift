//
//  AttentionVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let BriefCellID = "BriefCellID"
private let ScrollCardCellID = "ScrollCardCellID"

private var BriefCellH: CGFloat = choiCellH + briedAndScrollCardBarH + 20
private var ScrollCardH: CGFloat = choiCellH + briedAndScrollCardBarH + 20 + 44

class AttentionVC: BaseViewController {

    lazy var titleLab: UILabel = UILabel()
    var tableViewOriginalInsets: UIEdgeInsets?
    
    var newAttentionList = [AttItemListModel]()
    var attentionList = [AttItemListModel]()
    
    var nextPageUrl: String?
    let filePath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("AttentionNewData.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadNewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    func showAllAuthor() -> () {
        
        let nav = RootNavigationController.init(rootViewController: AllAuthorVC())
        present(nav, animated: true, completion: nil)
    }
    
}

//MARK: 请求网络数据
extension AttentionVC{
    
    func loadNewData() -> () {
        
        newAttentionList.removeAll()
        attentionList.removeAll()
        
        let params = ["start": "0","num": "2","follow": "false","startId": "0"]
        loadData(URLString: attUrlStr, parameters: params)
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
        
        let Attmodel = AttentionModel(dict: (json as! [String: Any]))
        nextPageUrl = Attmodel.nextPageUrl
        guard  let ItemArr = Attmodel.itemList else{
            
            return
        }
        
        for item in ItemArr {
            
            let AttItemModel = AttItemListModel(dict: (item as! [String : Any]))
            if !isPullup {
                    
                self.newAttentionList.append(AttItemModel)
            }
                self.attentionList.append(AttItemModel)
        }
        
        self.tableView.reloadData()
        self.endRefeshing()
        
    }
}

//MARK: 设置页面
extension AttentionVC{
    
    override func setUpNavBar() -> () {
        
        super.setUpNavBar()
        titleLab.text = "Subscrption"
        titleLab.font = UIFont.init(name: "Lobster 1.4", size: 24)
        titleLab.sizeToFit()
        
        navItem.titleView = titleLab
        navItem.leftBarButtonItem = UIBarButtonItem(title: "全部作者", titleColor: UIColor.black, titleFont: 12, target: self, action: #selector(showAllAuthor))
    }
    
    override func setUpTableView() {
        
        super.setUpTableView()
        
        tableView.register(AttentionBriefCell.self, forCellReuseIdentifier: BriefCellID)
        tableView.register(AttentionScrollCardCell.self, forCellReuseIdentifier: ScrollCardCellID)
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        tableViewOriginalInsets = tableView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

//MARK: 设置UITableView相关
extension AttentionVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return isPullup ? attentionList.count : newAttentionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let AttItemModel = attentionList[indexPath.row]
        switch AttItemModel.type! {
    
        case "videoCollectionWithBrief":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCellID, for: indexPath) as! AttentionBriefCell
            let attBriefDataModel = AttDataModel(dict: (AttItemModel.data ?? [:]))
            cell.attBriefDataModel = attBriefDataModel
            cell.normalView.delegate = self
            cell.attBriefBarView.conBtnClick = {
                
                self.present(LoginVC(), animated: true, completion: nil)
            }
            return cell
            
        case "videoCollectionOfHorizontalScrollCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ScrollCardCellID, for: indexPath) as! AttentionScrollCardCell
            let attScrollCardDataModel = AttDataModel(dict: (AttItemModel.data ?? [:]))
            cell.attScrollCardDataModel = attScrollCardDataModel
            cell.pageScrollView.delegate = self
            cell.attScrollCardBarView.conBtnClick = {
                
                self.present(LoginVC(), animated: true, completion: nil)
            }
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let AttItemModel = attentionList[indexPath.row]
        switch AttItemModel.type! {
            
        case "videoCollectionWithBrief":
            
            return BriefCellH
            
        case "videoCollectionOfHorizontalScrollCard":
            
            return ScrollCardH
        default:
            break
        }
        
        return 0
    }
    
}

//MARK: 设置NormalScrollView代理
extension AttentionVC: normalScrollViewDelegate{
    
    func scrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
    
}

//MARK: 设置PageScrollView代理
extension AttentionVC: PageScrollViewDelegate{
    
    func pageScrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
}

