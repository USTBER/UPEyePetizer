//
//  FindVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let HorizontalScrollCardID = "horizontalScrollCardID"
private let TextHeaderCellID = "textHeaderCellID"
private let SquareCardCellID = "SquareCardCellID"
private let VideoCellID = "videoCellID"
private var TextHeaderH: CGFloat = 44

private let ScrollCardCellID = "ScrollCardCellID"
private let BannerCollectionCellID = "BannerCollectionCellID"
private var BannerCollectionH: CGFloat = choiCellH + briedAndScrollCardBarH + 20
private var ScrollCardH: CGFloat = choiCellH + briedAndScrollCardBarH + 20 + 44

private let BriefCardCellID = "BriefCardCellID"
private let BriefCellID = "BriefCellID"
private let BlankCellID = "BlankCellID"
private var BriefCardCellH: CGFloat = briedAndScrollCardBarH
private var BriefCellH: CGFloat = choiCellH + 20


class FindVC: BaseViewController {

    var tableViewOriginalInsets: UIEdgeInsets?
    lazy var titleLab: UILabel = UILabel()
    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44

    var tabListUrl: [Int: String] = [:]
    var listUrlStr: String = ""
    var nextPageUrl: String?
    var newDataList = [ItemListModel]()
    var dataList = [ItemListModel]()
    
    lazy var loadingView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadTabListData()
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
                isPullup ? loadMoreData() : loadNewData(URLString: listUrlStr)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAllCategory() -> () {
        
        let nav = RootNavigationController.init(rootViewController: AllCategoryVC())
        present(nav, animated: true, completion: nil)
    }
    
}

//MARK: 请求网络数据
extension FindVC{
    
    func loadTabListData() -> () {
        
        var btnNameArrs = [String]()
        NetWorkManager.shared.request(URLString: findTabListUrlStr, parameters: [:]) { (json, isSuccess) in
            
            if isSuccess{
                
                guard let JsonDic = (json as? [String: AnyObject]),
                      let tabListDic = JsonDic["tabInfo"] as? [String: AnyObject],
                let tabListArr = tabListDic["tabList"] as? [[String: Any]] else{
                        
                        return
                }
                
                for i in 0..<tabListArr.count{
                    
                    let tabListModel = FindModel(dict: tabListArr[i])
                    btnNameArrs.append(tabListModel.name!)
                    self.tabListUrl[tabListModel.TabListId] = tabListModel.apiUrl
                }
                
                let barView: PageScrollBarView = PageScrollBarView(frame: CGRect(x: 0, y: self.navigationBar.bounds.height, width: self.barW, height: self.barH))
                barView.btnNameArrs = btnNameArrs
                barView.delegate = self
                self.view.addSubview(barView)
            
                //第一次加载数据
                self.listUrlStr = self.tabListUrl[0]!
                self.loadNewData(URLString: self.listUrlStr)
            }
            
        }
    }
    
    func loadNewData(URLString: String) -> () {
        
        newDataList.removeAll()
        dataList.removeAll()

        loadData(URLString: URLString, parameters: [:])
    }
    
    func loadMoreData() -> () {
        
        loadData(URLString: nextPageUrl!, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            if isSuccess{
                
                dicToJsonWithTabListId(json: json!)
        }
    }
    
    func dicToJsonWithTabListId(json: Any) -> () {
        
        let model = ChoicenessModel(dict: (json as! [String: Any]))
        self.nextPageUrl = model.nextPageUrl
        guard  let FindItemArr = model.itemList else{
            
            return
        }
        
        for item in FindItemArr {
            
        let FindItemModel = ItemListModel(dict: (item as! [String : Any]))
        if !self.isPullup {
                
                self.newDataList.append(FindItemModel)
            }
            
                self.dataList.append(FindItemModel)
            
        }

        self.tableView.reloadData()
        self.endRefeshing()
        
        }
    }
}

//MARK: 设置界面
extension FindVC{
    
    override func setUpNavBar() -> () {
        
        super.setUpNavBar()
        
        titleLab.text = "Discover"
        titleLab.font = UIFont.init(name: "Lobster 1.4", size: 24)
        titleLab.sizeToFit()
        
        navItem.titleView = titleLab
        navItem.leftBarButtonItem = UIBarButtonItem(title: "全部分类", titleColor: UIColor.black, titleFont: 12, target: self, action: #selector(showAllCategory))
    }
    
    override func setUpTableView() {
        
        super.setUpTableView()
        
        tableView.register(BannerScrollCell.self, forCellReuseIdentifier: HorizontalScrollCardID)
        tableView.register(UINib(nibName: "textFooterCell", bundle: nil), forCellReuseIdentifier: TextHeaderCellID)
        tableView.register(HotSquareCardCell.self, forCellReuseIdentifier: SquareCardCellID)
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: VideoCellID)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BannerCollectionCellID)
        tableView.register(AttentionScrollCardCell.self, forCellReuseIdentifier: ScrollCardCellID)
       
        tableView.register(AuthorBriefCardCell.self, forCellReuseIdentifier: BriefCardCellID)
        tableView.register(AuthorBriefCell.self, forCellReuseIdentifier: BriefCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BlankCellID)
        
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height + barH, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        tableViewOriginalInsets = tableView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

//MARK: 设置tableView相关
extension FindVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isPullup ? dataList.count : newDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataList.count == 0{
            
            return UITableViewCell()
        }
        
        let ItemModel = dataList[indexPath.row]
        switch ItemModel.type! {
            
        case "horizontalScrollCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalScrollCardID, for: indexPath) as! BannerScrollCell
            cell.bannerScrollCellData = ItemModel.data
            return cell
        case "textHeader":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextHeaderCellID, for: indexPath) as! textFooterCell
            let textFooterModel = textFooterDataModel(dict: (ItemModel.data ?? [:]))
            cell.textFooterModel = textFooterModel
            return cell
        case "video":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCellID, for: indexPath) as! VideoCell
            let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
            cell.videoModel = videoModel
            return cell
        case "squareCardCollection":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SquareCardCellID, for: indexPath) as! HotSquareCardCell
            let squareCardDataModel = AttDataModel(dict: (ItemModel.data ?? [:]))
            cell.squareCardDataModel = squareCardDataModel
            return cell
        
        case "bannerCollection":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerCollectionCellID, for: indexPath)
            return cell
            
        case "videoCollectionOfHorizontalScrollCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ScrollCardCellID, for: indexPath) as! AttentionScrollCardCell
            let attScrollCardDataModel = AttDataModel(dict: (ItemModel.data ?? [:]))
            cell.attScrollCardDataModel = attScrollCardDataModel
            cell.pageScrollView.delegate = self
            cell.attScrollCardBarView.conBtnClick = {
                
                self.present(LoginVC(), animated: true, completion: nil)
            }
            return cell

        case "briefCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCardCellID, for: indexPath) as! AuthorBriefCardCell
            let authorBriefData = ItemModel.data
            cell.authorBriefData = authorBriefData
            cell.attBriefBarView.conBtnClick = {
                
                self.present(LoginVC(), animated: true, completion: nil)
            }
            return cell
            
        case "videoCollectionWithBrief":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefCellID, for: indexPath) as! AuthorBriefCell
            let authorBriefDataModel = AttDataModel(dict: (ItemModel.data ?? [:]))
            cell.authorBriefDataModel = authorBriefDataModel
            cell.normalView.delegate = self
            return cell
            
        case "leftAlignTextHeader","blankCard":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BlankCellID, for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
            
        default:
            
            return UITableViewCell()
           
   
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataList.count == 0{
            
            return 0
        }
        
        let ItemModel = dataList[indexPath.row]
        switch ItemModel.type! {
            
        case "horizontalScrollCard":
            
            return choiCellH
            
        case "textHeader":
            
            return TextHeaderH
        case "video":
            
            return choiCellH
        case "squareCardCollection":
            
            return (choiCellH + briedAndScrollCardBarH - 20)
            
        case "bannerCollection":
        
             return 0
            
        case "videoCollectionOfHorizontalScrollCard":
            
            return ScrollCardH
            
        case "briefCard":
            
            return BriefCardCellH
            
        case "videoCollectionWithBrief":
            
            return BriefCellH
            
        case "leftAlignTextHeader","blankCard":
            
            return TextHeaderH
            
        default:
            
            return 0
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.isKind(of: VideoCell.self))! {
            
            if dataList.count == 0 {return}
            let ItemModel = dataList[indexPath.row]
            let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
            let videoPlayVC = VideoDetailVC()
            videoPlayVC.videoDataModel = videoModel
            navigationController?.present(videoPlayVC, animated: true, completion: nil)
            
        }else if (cell?.isKind(of: AuthorBriefCardCell.self))!{
            
            let AuthorItemModel = dataList[indexPath.row]
            let authorHeadVC = AuthorIntroduceVC()
            authorHeadVC.authorHeadData = AuthorItemModel.data
            navigationController?.pushViewController(authorHeadVC, animated: true)

        }

    }
}

//MARK: 设置PageScrollBarViewDelegate相关
extension FindVC: PageScrollBarViewDelegate{
    
    func btnClick(btn: UIButton) {
        
        tableView.contentOffset = CGPoint(x: 0, y: -(navigationBar.bounds.size.height + barH))
        let requestUrlStr = tabListUrl[btn.tag] ?? ""
        listUrlStr = requestUrlStr
        loadNewData(URLString: requestUrlStr)
    }
}

//MARK: 设置NormalScrollView代理
extension FindVC: normalScrollViewDelegate{
    
    func scrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
    
}
//MARK: 设置PageScrollView代理
extension FindVC: PageScrollViewDelegate{
    
    func pageScrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
}
