//
//  UIPageController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class PageInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var getData: Product?
 
    let titleDic = [2: NSLocalizedString("size", comment: ""),
                    3: NSLocalizedString("stock", comment: ""),
                    4: NSLocalizedString("texture", comment: ""),
                    5: NSLocalizedString("wash", comment: ""),
                    6: NSLocalizedString("place", comment: ""),
                    7: NSLocalizedString("note", comment: "")]
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var footerBtn: UIButton!
    @IBOutlet weak var listInfoTableView: UITableView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var pageChange: UIPageControl!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    // swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let getData = getData else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            
            if let infoDesCell = tableView.dequeueReusableCell(
                withIdentifier: "descriptionCell", for: indexPath) as? ProductDescriptionCell {
                
                infoDesCell.backgroundColor = .white
                infoDesCell.showInfo(
                    titleText: getData.title, priceText: getData.price,
                    idNumber: getData.id, descText: getData.story)
            
                return infoDesCell
            }
        } else if indexPath.row == 1 {
            
            guard let infoColorCell = tableView.dequeueReusableCell(
                withIdentifier: "infoColorCell", for: indexPath) as? ProductInfoColorCell
            else { return UITableViewCell() }
            
            infoColorCell.setupView(showColor: getData.colors.map({ (code) -> String in
                code.code
            }))
            
            return infoColorCell
            
        } else {
            if let infoStringCell = tableView.dequeueReusableCell(
                withIdentifier: "infoStringCell", for: indexPath) as? ProductInforStringCell {
                
                let title = titleDic[indexPath.row] ?? ""
                switch indexPath.row {
                case 2:
                    infoStringCell.showInfo(titleText: title, infoText: getData.sizes.joined(separator: " - "))
                case 3:
                    let stockNum = getData.variants.reduce(0) { (sum, num) -> Int in
                        sum + num.stock
                    }
                    infoStringCell.showInfo(titleText: title, infoText: String(stockNum) )
                case 4:  infoStringCell.showInfo(titleText: title, infoText: getData.texture)
                case 5: infoStringCell.showInfo(titleText: title, infoText: getData.wash)
                case 6: infoStringCell.showInfo(titleText: title, infoText: getData.place)
                case 7: infoStringCell.showInfo(titleText: title, infoText: getData.note)
                default:
                    break
                }
                return infoStringCell
            }
        }
        return UITableViewCell()
    }
     // swiftlint:eable cyclomatic_complexity
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listInfoTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let getData = getData else {
            return nil
        }
        
        return PageInfoHeaderView(numberOfImage: getData.images.count, images: getData.images)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
     // MARK: - 進入 orderViewVC Btn
    func setupBtn() {
        footerBtn.setTitle(NSLocalizedString("addtoCart", comment: ""), for: .normal)
        footerBtn.setTitleColor(.white, for: .normal)
        footerBtn.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        print(footerBtn.frame)
    }
    @IBOutlet weak var hideView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let  orderVc = segue.destination as? OrderViewController  else { return }
        orderVc.getOrderData = getData
        orderVc.viewBackground = hideView
        hideView.isHidden = false
        hideView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    }
    
    // MARK: - 返回按鈕
    @IBAction func backBtnAction(_ sender: Any) {
      //返回時不隱藏 navigationbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popViewController(animated: true)
        
    }
    // MARK: - 狀態列的顯示
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 隱藏 navigationbar
        navigationController?.setNavigationBarHidden(true, animated: true)

        listInfoTableView.delegate = self
        listInfoTableView.dataSource = self
        
        listInfoTableView.rowHeight = UITableView.automaticDimension
        listInfoTableView.estimatedRowHeight = 200
        
        //  setBackBtn()
        setupBtn()
        
    }
    
}
