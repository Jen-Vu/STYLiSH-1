//
//  OrderListViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import CoreData

struct ShowCell {
    let title: String
    var num: Int
}

class OrderListViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, OrderListTableViewCellDelegate {
    
    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var noItemLabel: UILabel!
    
    var productAdd: [AddCarInfo] = [] {
        
        didSet {
            if productAdd.count > 0 {
                setCheckBtn(.enable)
                noItemLabel.isHidden = true
            } else {
                setCheckBtn(.disable)
                noItemLabel.isHidden = false
                noItemLabel.text = NSLocalizedString("noitem", comment: "")
            }
        }
    }
    // MARK: - tableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productAdd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderCell = orderListTableView.dequeueReusableCell(
            withIdentifier: "orderCell", for: indexPath) as? OrderListTableViewCell
            else { return UITableViewCell() }
        
        orderCell.delegate = self
        orderCell.orderListVC = self
        orderCell.indexPath = indexPath
        
        let product = productAdd[indexPath.row]
        
        orderCell.productTitle.text = product.title ?? " Loading"
        orderCell.productSize.text = product.size ?? " Loading"
        orderCell.productPrice.text = String(product.price)
        let url = URL(string: product.image ?? "NO Image" )
        orderCell.productImage.kf.setImage(with: url)
        orderCell.colorView.backgroundColor = UIColor(hexString: "#\(product.colorCode ?? "FFFFFF")")
        orderCell.textField.text = String(product.selectNum)
        orderCell.selectNum = Int(productAdd[indexPath.row].selectNum)
        orderCell.setBtnStatus()
        
        print(product.colorName ?? "")
        return orderCell
    }
    
    func changeSelectNum(_ cell: OrderListTableViewCell, selectNum: Int) {
        guard let indexPath = orderListTableView.indexPath(for: cell) else { return }
        // 將改變後的數值存入 array 中
        productAdd[indexPath.row].selectNum = Int16(selectNum)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderListTableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - removeCellBtn
    func removeCellBtn(_ cell: OrderListTableViewCell) {
        
        guard let indexPath = orderListTableView.indexPath(for: cell) else { return }
        let context = StorageManager.shared.persistentContainer.viewContext
        
        context.delete(productAdd[indexPath.row])
        productAdd.remove(at: indexPath.row)
        StorageManager.shared.saveContext()
        orderListTableView.deleteRows(at: [indexPath], with: .right)
    
    }
    
    // MARK: - CheckBtn
    func setCheckBtn(_ status: BtnStatus ) {
        
        checkBtn.setTitle(NSLocalizedString("gotoCheckoutBtn", comment: ""), for: .normal)
        checkBtn.setTitleColor(.white, for: .normal)
        
        switch status {
        case .enable:
            checkBtn.isEnabled = true
            checkBtn.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        case .disable:
            checkBtn.isEnabled = false
            checkBtn.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        }
        
    }
    
    @IBAction func goToCheckout() {
     
        if let checkoutVC = storyboard?.instantiateViewController(
            withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            
            navigationController?.pushViewController(checkoutVC, animated: true)
        }
    }

    @objc func showBarBadge(notification: NSNotification) {
       productAdd = StorageManager.shared.getAddCarInfos()
        navigationController?.tabBarItem.badgeValue = String(productAdd.count)
        navigationController?.tabBarItem.badgeColor = .brown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderListTableView.dataSource = self
        orderListTableView.delegate = self
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(showBarBadge(notification:)),
                                               name: StorageManager.shared.notification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
       productAdd =  StorageManager.shared.getAddCarInfos()
        orderListTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
