//
//  OrderListTableViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import CoreData

protocol OrderListTableViewCellDelegate: AnyObject {
    
    func changeSelectNum(
        _ cell: OrderListTableViewCell,
        selectNum: Int
        )
    
    func removeCellBtn(_ cell: OrderListTableViewCell)
}

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: OrderListTableViewCellDelegate?
    weak var orderListVC: OrderListViewController?
    var indexPath: IndexPath?
    
    var selectNum = 0 {
        didSet {
            
            textField.text = String(selectNum)
            changeSelectNum()
            StorageManager.shared.saveContext()
            
        }
    }
    
    func changeSelectNum() {
        //存取 cell 改變後的數值
        delegate?.changeSelectNum(self, selectNum: selectNum)
    }

    @IBAction func clickAddBtn(_ sender: Any) {
        selectNum += 1
    
    }
    
    @IBAction func clickSubBtn(_ sender: Any) {
        if selectNum != 0 {
            selectNum -= 1
        }
    }
    @IBAction func removeCellBtn(_ sender: Any) {
        print("Hit!!")

        delegate?.removeCellBtn(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNumBtnLayout(btn: UIButton, _ status: BtnStatus) {
        switch status {
        case .enable:
            btn.isUserInteractionEnabled = true
            btn.alpha = 1
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
        case .disable:
            btn.isUserInteractionEnabled = false
            btn.alpha = 0.3
            btn.layer.borderWidth = 1
        }
    }
    
    func setBtnStatus() {
        
        setNumBtnLayout(btn: addBtn, selectNum >= 0 ? .enable : .disable)
        setNumBtnLayout(btn: subBtn, selectNum != 0 ? .enable : .disable)
        
    }
}
