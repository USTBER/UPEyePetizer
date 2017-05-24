//
//  AllCategoryVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let itemMargin: CGFloat = 5
private let itemWH: CGFloat = (UIScreen.main.bounds.width - itemMargin * 3) / 2

class AllCategoryVC: BaseViewController {

    let collectionView: UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    var categoryList = [AttItemListModel]()
    let filePath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("CategoryData.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadNewData()
        setUpCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popVC() -> () {
        
        dismiss(animated: true, completion: nil)
    }

}

//MARK: 设置界面
extension AllCategoryVC{
    
    override func setUpNavBar() {
        
        super.setUpNavBar()
        
        let backImg = UIImage(named: "Action_close_44x44_") ?? UIImage()
        navItem.addLeftCloseBtn(backBtnImg: backImg)
        navItem.leftBtnCloseClick = {
            
            self.dismiss(animated: true, completion: nil)
        }
        navItem.title = "全部分类"
    }
    
    override func setUpTableView() {}
    
    func setUpCollectionView() -> () {
    
        
        collectionView.frame = view.bounds
        collectionView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, 0, 0)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryItem")
        view.insertSubview(collectionView, belowSubview: navigationBar)
    }
}

//MARK: 请求网络数据
extension AllCategoryVC{
    
    func loadNewData() -> () {

        loadData(URLString: categoryUrlStr, parameters: [:])
    }
    
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            if isSuccess{
                
            //将新获取的数据存入沙盒，当网络请求失败时可以使用
            let JsonDic = (json as? [String: AnyObject]) ?? [:]
            guard let data = try? JSONSerialization.data(withJSONObject: JsonDic, options: .prettyPrinted) else{
                        
                return
            }
                    
            (data as NSData).write(toFile: self.filePath, atomically: true)
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
        
        let CategoryModel = AttentionModel(dict: (json as! [String: Any]))
        guard  let ItemArr = CategoryModel.itemList else{
            
            return
        }
        
        for item in ItemArr {
            
            let CategoryItemModel = AttItemListModel(dict: (item as! [String : Any]))
            if  CategoryItemModel.type == "squareCard" || CategoryItemModel.type == "rectangleCard"{
                
                self.categoryList.append(CategoryItemModel)
            }
        
        }
        
        collectionView.reloadData()
    }
}

//MARK: 设置CollectionView相关
extension AllCategoryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoryItemModel = categoryList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryItem", for: indexPath) as! CategoryCell
        cell.categoryData = categoryItemModel.data
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {//热门排行榜
            
            navigationController?.pushViewController(HotRankVC(), animated: true)
        }else if indexPath.item == 1{//热门专题
            
            navigationController?.pushViewController(ChooseHotVC(), animated: true)
        }else if indexPath.item == 2{//全景视频
            
            navigationController?.pushViewController(AllProjectVC(), animated: true)
        }else{//其他
            
            let categoryItemModel = categoryList[indexPath.item]
            let categoryData = categoryItemModel.data
            let categoryDetailVC = CategoryDetailVC()
            categoryDetailVC.categoryData = categoryData
            navigationController?.pushViewController(categoryDetailVC, animated: true)
        }
    }
    
    //设定全局的Cell尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2 {
            
            return CGSize(width: (UIScreen.main.bounds.width - 2 * itemMargin), height: itemWH)
        }else{
            
            return CGSize(width: itemWH, height: itemWH)
        }
    }
    
    //设定全局的区内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin)
    }
 
    //设定全局的行间距，即上下两行
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return itemMargin
    }
    
 
    //设定全局的Cell间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return itemMargin
    }
 
}

