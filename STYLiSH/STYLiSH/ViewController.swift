//
//  ViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher
import CRRefresh

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MarketManagerDelegate {
    
    //  連接 controller 到知道 tableView
    @IBOutlet weak var itemTableView: UITableView!
    
    //  section 個數
    func numberOfSections(in tableView: UITableView) -> Int {
        //  print("\(dataInfo.count)")
        return getDataInfo.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HotHeaderView(title: getDataInfo[section].title)
    }
    //    Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
    //  cell的數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return getDataInfo[section].products.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            if let evevCell = tableView.dequeueReusableCell(withIdentifier: "evevCell") as? HotEvenTableViewCell {

                let productInfo = getDataInfo[indexPath.section].products[indexPath.row]
                evevCell.setupViewWith(product: productInfo)
                return evevCell
            }
            return UITableViewCell()
        } else {
            guard
                let oddCell = tableView.dequeueReusableCell(withIdentifier: "oddCell") as? HotOddTableViewCell
            else {
                return UITableViewCell()
                
            }
            // Set up cell.textField`
            
            let productInfo = getDataInfo[indexPath.section].products[indexPath.row]
            oddCell.setupViewWith(product: productInfo)
            return oddCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemTableView.deselectRow(at: indexPath, animated: false) //取消置灰停留
        
        if let listVC = storyboard?.instantiateViewController(
                withIdentifier: "pageInfoController"
            ) as? PageInfoController {
            
            let getHotsData = getDataInfo[indexPath.section].products[indexPath.row]
            listVC.getData = getHotsData
            
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    let marketManger = MarketManager()
    var getDataInfo: [Hots] = []
    func manager(_ manager: MarketManager, didGet marketingHots: [Hots]) {
        getDataInfo = marketingHots
        //        print("\(dataInfo[0].title)!!")
        DispatchQueue.main.async {
            //            print("=====")
            self.itemTableView.cr.endHeaderRefresh() //關閉下拉更新
            self.itemTableView.reloadData() // 拿到資料後畫畫面
        }
        
    }
    
    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.rowHeight = UITableView.automaticDimension
        itemTableView.estimatedRowHeight = 100
        navigationItem.titleView = UIImageView(image: UIImage(named: "Image_Logo02"))
        
        marketManger.delegate = self
        //手動下拉refresh ＆ 重新抓資料
        itemTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.marketManger.getMarketingHots()
        }
        // 載入時自動refresh
        self.itemTableView.cr.beginHeaderRefresh()
    }
    
}
