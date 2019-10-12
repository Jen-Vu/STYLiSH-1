//
//  ListViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/15.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Alamofire
import CRRefresh

class ListViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate,
    ProducListDelegate, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var acsBtn: UIButton!
    
    var listInfo: [Product] = []
    var paging: Int = 0
    var listCategory: ListCategory = .women
    
    // MARK: - CollectionViewList
    
    let cellLocation = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    
    //    section位置
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return cellLocation
    }
    //    cell 數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listInfo.count
    }
    //cell 的大小
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellLeft = cellLocation.left
        let size = ((UIScreen.main.bounds.width - (cellLeft * 2)) * 164 / 375) .rounded(.down)
        let  itemSize = CGSize(width: size, height: 284)
        
        return itemSize
    }
    // cell 間距
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let cellLeft = cellLocation.left
        let size = ((UIScreen.main.bounds.width - (cellLeft * 2)) * 15 / 375) .rounded(.down)
        let  itemSize = size
        return itemSize
    }
    // cell 高度
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 24
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let listCell = listCollectionView.dequeueReusableCell(
            withReuseIdentifier: "listCollectionViewCell", for: indexPath
            ) as? ListCollectionViewCell {
            
            let getData = listInfo[indexPath.row]
            listCell.showListInfo(image: getData.mainImage, text: getData.title, desc: getData.description)
            return listCell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let listVC = storyboard?.instantiateViewController(
            withIdentifier: "pageInfoController") as? PageInfoController {
            
            let getData = listInfo[indexPath.row]
            listVC.getData = getData
            
            listCollectionView.deselectItem(at: indexPath, animated: false)
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    // MARK: - TableViewList
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellList = tableView.dequeueReusableCell(withIdentifier: "cellList") as? ItemListTableViewCell {
            let productItem = listInfo[indexPath.row]
            
            cellList.setupViewWith(image: productItem.mainImage, title: productItem.title, price: productItem.price)
            return cellList
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listTableView.deselectRow(at: indexPath, animated: false)
        if let listVC = storyboard?.instantiateViewController(
            withIdentifier: "pageInfoController") as? PageInfoController {
            
            let getData = listInfo[indexPath.row]
            listVC.getData = getData
            
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    // MARK: - Navigationbar
    // 定義 Btn
    let barButton = UIButton(type: .system)
    let barTableImage = UIImage(named: "Icons_24px_ListView")?.withRenderingMode(.alwaysOriginal)
    let barCollectionImage = UIImage(named: "Icons_24px_CollectionView")?.withRenderingMode(.alwaysOriginal)
    
    // 指定給 navigationItem
    func setupNavigationbarButton() {
        barButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: barCollectionImage, style: .plain, target: self, action: #selector(clickBtn(_:)))
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        
        listTableView.isHidden = !listTableView.isHidden
        listCollectionView.isHidden = !listCollectionView.isHidden
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: !listTableView.isHidden ? barCollectionImage : barTableImage,
            style: .plain, target: self, action: #selector(clickBtn(_:)))
    }
    
    // 不顯示 Navigationbar 下方底線
    func hideNavigationbarUderLine() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
     // MARK: - ListCategory Btn
    @IBOutlet weak var clickLine: UIView!
    
    //更改 Btn 被觸發時的狀態
    @IBAction func changBtn(_ sender: UIButton) {
        isSelect(sender: sender)
    }
    //重置 Btn 的狀態
    func resetBtn(_ sender: UIButton) {
        sender.setTitleColor(.lightGray, for: .normal)
    }
    
    func isSelect(sender: UIButton) {
        // 被選取時的 Btn 顯示
        sender.setTitleColor(.darkGray, for: .normal)
    
        resetBtn(menBtn)
        resetBtn(womenBtn)
        resetBtn(acsBtn)
        
        // 利用 view 的 center 製作動畫效果
        UIView.animate(withDuration: 0.3) {
            switch sender {
            case self.menBtn: self.clickLine.center = CGPoint(x: UIScreen.main.bounds.width * 3 / 6, y: 42)
            case self.womenBtn: self.clickLine.center = CGPoint(x: UIScreen.main.bounds.width * 1 / 6, y: 42)
            case self.acsBtn: self.clickLine.center = CGPoint(x: UIScreen.main.bounds.width * 5 / 6, y: 42)
            default: break
            }
        }
        
        // 切換 Btn 要顯示的資料
        switch sender {
        case self.womenBtn: listCategory = .women
        case self.menBtn: listCategory = .men
        case self.acsBtn: listCategory = .accessories
        default: break
        }
        
        print("List data is \(self.listCategory)")
        self.listInfo = [] //將原本資料清空
        self.paging = 0 // 重置 paging
        self.listCollectionView.cr.resetNoMore()
        self.listTableView.cr.resetNoMore()
        // 呼叫 API 拿不同 Category 的資料
        self.productList.getProducts(for: self.listCategory, paging: self.paging)
    }
    
    // MARK: - 拿取 API 解碼後的資料呈現在畫面
    let productList = ProductListAPI()
  
    func manager(_ manager: ProductListAPI, didGet marketingListData: List) {
     
        if marketingListData.paging == nil {
            //告訴tableView滑到最底不用撈資料
            listTableView.cr.noticeNoMoreData()
            listTableView.cr.footer?.alpha = 1.0
            listCollectionView.cr.noticeNoMoreData()
            listCollectionView.cr.footer?.alpha = 1.0
        }
        
        if marketingListData.data.count >= 0 {
            // 堆疊（加入）下一頁的 item
            listInfo.append(contentsOf: marketingListData.data)
          
            // Update UI on main queue
            DispatchQueue.main.async {
                //關閉 HeadRefresh 的 Loading
                self.listTableView.cr.endHeaderRefresh()
                self.listCollectionView.cr.endHeaderRefresh()
                //關掉 FootRefresh 的 Loading
                self.listTableView.cr.endLoadingMore()
                self.listCollectionView.cr.endLoadingMore()
                
                self.listTableView.reloadData()
                print("tableView:\(self.listInfo.count)")
                self.listCollectionView.reloadData()
                print("listCollectionView:\(self.listInfo.count)")
            }
        }
    }
    
    func manager(_ manager: ProductListAPI, didFailWith error: Error) {
        print(error)
    }
    
    // MARK: - Refresh (Third-party library : CRrefresh)
    func refreshTableView() {
        
        // pull-down-refresh
        listTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {

            self.listInfo = [] // listInfo 資料清除
            self.paging = 0 // 重置 paging
            self.listTableView.cr.resetNoMore() // 重置 no more data
            //手動下拉refresh ＆ 重新抓資料
            self.productList.getProducts(for: self.listCategory, paging: self.paging)
            print("我有在更新")

        }
        // load-more function
        listTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            //若有其他頁的話 pageing +1
            self.paging += 1
            self.productList.getProducts(for: self.listCategory, paging: self.paging)
            print("我正在抓更多資料")
        }
    }
    
    func refreshCollectionView() {
        listCollectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            
            self.listInfo = [] // listInfo 資料清除
            self.paging = 0 // 重置 paging
            self.listCollectionView.cr.resetNoMore() // 重置 no more data
            //手動下拉refresh ＆ 重新抓資料
            self.productList.getProducts(for: self.listCategory, paging: self.paging)
            print("我有在更新")
        }
        
        listCollectionView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            //若有其他頁的話 pageing +1
            self.paging += 1
            self.productList.getProducts(for: self.listCategory, paging: self.paging)
            print("我正在抓更多資料")
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationbarUderLine()
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        productList.listDelegate = self
        
        listTableView.rowHeight = 134
        listTableView.estimatedRowHeight = 0
        womenBtn.setTitleColor(.darkGray, for: .normal) //初始化 womenBtn
        
        refreshTableView()
        refreshCollectionView()
        productList.getProducts(for: listCategory, paging: self.paging)
        print("第一次呼叫資料")
        setupNavigationbarButton()
        listCollectionView.isHidden = true
        
    }
    
}
