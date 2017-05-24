//
//  BaseViewController.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

enum refreshState {
    case StateNormal
    case StateWillRefresh
    case StateRefreshing
}

let RefreshViewObserveKeyPath = "contentOffset"

class BaseViewController: UIViewController{

    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    lazy var navItem: NavItem = NavItem()
    lazy var tableView: UITableView = UITableView()
    
    lazy var headerView: HeadAndFootRefreshView = HeadAndFootRefreshView()
    lazy var footerView: HeadAndFootRefreshView = HeadAndFootRefreshView()
    
    var superTableViewOriginalInsets: UIEdgeInsets?
    var isPullup: Bool = false
    var refreshing: refreshState?
    //刷新控件在刷新时的偏移量
    var headerViewOffserY: CGFloat = 60
    var footerViewOffsetY: CGFloat = 100
    
    var childNeedRefresh: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNavBar()
        setUpTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 监听contentOffset的变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath != RefreshViewObserveKeyPath {
            
            return
        }
    
        if childNeedRefresh {
            
            updateRefreshHeaderOrFooter(OffsetY: tableView.contentOffset.y)
        }
        
    }
    
    func updateRefreshHeaderOrFooter(OffsetY: CGFloat) -> () {
        
        //print("offsetY = \(OffsetY)")
        if OffsetY < -(tableView.contentInset.top + headerViewOffserY) {//准备下拉刷新,根据子类设置的contentInset.top来判断是否需要刷新
    
            if tableView.isDragging && refreshing != refreshState.StateWillRefresh {
                
                refreshing = refreshState.StateWillRefresh
                
            }else if !tableView.isDragging && refreshing == refreshState.StateWillRefresh{
                
                print("下拉刷新")
                isPullup = false
                refreshing = refreshState.StateRefreshing
            }
            
        }else{//准备上拉加载
            
            //因为tableView在设置时向上偏移了，所以在计算是否滑到底部时需要加上偏移量
            let ViewOffsetY = tableView.contentSize.height - tableView.bounds.height + (tabBarController?.tabBar.bounds.height ?? 49)
            //第一次加载时由于tableView还没有加载完成，因此根据contentSize计算出的ViewOffsetY会小于tableView.contentOffset.y，造成已经滑到底部的假象，因此需要多加一层判断过滤
            if tableView.contentOffset.y > ViewOffsetY{
                
                if tableView.isDragging && refreshing != refreshState.StateRefreshing{
                    
                    footerView.frame = CGRect(x: (navigationBar.bounds.width - 42)/2, y: tableView.contentSize.height + 10, width: 42, height: 28)
                    footerView.isHidden = false
                    refreshing = refreshState.StateWillRefresh
                    
                }else if !tableView.isDragging && refreshing == refreshState.StateWillRefresh{
                    
                    if OffsetY > (ViewOffsetY + 42) {
                        
                        print("上拉加载")
                        isPullup = true
                        refreshing = refreshState.StateRefreshing
                    }
                    
                }
            }
            
            if refreshing == refreshState.StateNormal {
                
                footerView.isHidden = true
            }
        }
    }
    
    func endRefeshing() -> () {
        
        refreshing = refreshState.StateNormal
        
        UIView.animate(withDuration: 0.2) {
            
            self.tableView.contentInset = self.superTableViewOriginalInsets ?? UIEdgeInsetsMake(self.navigationBar.bounds.size.height, 0, 49, 0)
        }
        isPullup ? footerView.stopAnima() : headerView.stopAnima()
    }

    deinit {
        
        if tableView.frame == CGRect() {
            
            return
        }
        
        tableView.removeObserver(self, forKeyPath: RefreshViewObserveKeyPath)
    }
}

//MARK: 设置界面
extension BaseViewController{
    
    func setUpNavBar() -> () {
        
        //取消自动缩进，如果隐藏导航栏，则缩进20
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]

    }
    
    func setUpTableView() -> () {
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.insertSubview(tableView, belowSubview: navigationBar)
        refreshing = refreshState.StateNormal
        
        //添加监听者，监听contentOffset的变化，设置下拉刷新河上拉加载
        tableView.addObserver(self, forKeyPath: RefreshViewObserveKeyPath, options: NSKeyValueObservingOptions.new, context: nil)
        headerView.frame = CGRect(x: (navigationBar.bounds.width - 42)/2, y: -42, width: 42, height: 28)
        footerView.isHidden = true
        tableView.addSubview(headerView)
        tableView.addSubview(footerView)
        
    }
}

//MARK: UITableViewDataSource and UITableViewDelegate
extension BaseViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshing == refreshState.StateRefreshing {
            
            isPullup ? footerView.startAnima() : headerView.startAnima()
        }
    }
}


