//
//  CheckoutViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import AdSupport

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var checkoutTableView: UITableView!
    
    let header = [NSLocalizedString("Item", comment: ""),
                  NSLocalizedString("recipient", comment: ""),
                  NSLocalizedString("Payment", comment: "")]
    let products = StorageManager.shared.getAddCarInfos()
    
    var userPersonalInfoIsFinished = false {
        didSet {
            updateCheckoutBtnStatus()
        }
    }
    var paymentInfoIsFinished = false {
        didSet {
            updateCheckoutBtnStatus()
        }
    }
    var userInfo: Recipient?
    var getPrime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutTableView.delegate = self
        checkoutTableView.dataSource = self
        
        checkoutTableView.lk_registerCellWithNib(identifier: String(describing: STOrderProductCell.self), bundle: nil)
        
        checkoutTableView.lk_registerCellWithNib(identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        
        checkoutTableView.lk_registerCellWithNib(
            identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        
        checkoutTableView.register(headerXib,
                                   forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "Icons_24px_Back02"), style: .plain, target: self, action: #selector(back))
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {                
                return nil
        }
        
        headerView.titleLabel.text = header[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        
        footerView.contentView.backgroundColor = UIColor(hexString: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return products.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userCell: UITableViewCell
        
        if indexPath.section == 0 {
            let product = products[indexPath.row]
            userCell = checkoutTableView.dequeueReusableCell(
                withIdentifier: String(describing: STOrderProductCell.self), for: indexPath)
            guard let productCell = userCell as? STOrderProductCell else {
                return userCell
            }
            productCell.productTitleLabel.text = product.title
            productCell.productSizeLabel.text = product.size
            productCell.priceLabel.text = String(product.price)
            productCell.colorView.backgroundColor = UIColor(hexString: product.colorCode ?? "FFFFFF")
            productCell.orderNumberLabel.text = "x\(String(product.selectNum))"
            let url = URL(string: product.image ?? "")
            productCell.productImageView.kf.setImage(with: url)
            
        } else if indexPath.section == 1 {
            userCell = checkoutTableView.dequeueReusableCell(
                withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath)
            
            guard let userInputCell = userCell as? STOrderUserInputCell else {
                return userCell
            }
            
            userInputCell.delegate = self
            
        } else {
            userCell = checkoutTableView.dequeueReusableCell(
                withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath)
            guard let paymentCell = userCell as? STPaymentInfoTableViewCell else {
                return userCell
            }
            paymentCell.delegate = self
            
            paymentCell.layoutCellWith(
                productPrice: calculationItemprice(), shipPrice: 60, productCount: calculationItemNum())
            
            // 設定“貨到付款”為預設值
            paymentInfoIsFinished = paymentCell.paymentTextField.text == PaymentMethod.cash.rawValue
            setBtnStatus(userPersonalInfoIsFinished && paymentInfoIsFinished ? .enable : .disable,
                         btn: paymentCell.checkBtn)
            
            return paymentCell
        }
        
        return userCell
    }
    
    func calculationItemprice() -> Int {
        var totalPrice = 0
        for orderItem in products {
            totalPrice += Int((orderItem.price) * (orderItem.selectNum))
        }
        return totalPrice
    }
    
    func calculationItemNum() -> Int {
        let totalCount = products.reduce(0, { (sum, num) -> Int in
            sum + Int(num.selectNum)
        })
        return totalCount
    }
}

// swiftlint:disable function_parameter_count
extension CheckoutViewController: STOrderUserInputCellDelegate {
    
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String) {
        
        userInfo = Recipient(name: username, phone: phoneNumber, email: email, address: address, time: shipTime)
        check(recipient: userInfo!)
    }
    
    func check(recipient: Recipient) {
        
        if recipient.name != "" &&
            recipient.phone != "" &&
            recipient.email != "" &&
            recipient.address != "" &&
            recipient.time != "" {
            
            userPersonalInfoIsFinished = true
            
        } else {
            userPersonalInfoIsFinished = false
        }
    }
}
// swiftlint:enable function_parameter_count
extension CheckoutViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        checkoutTableView.reloadData()
    }
    
    // MARK: - 設置 Btn 狀態
    func setBtnStatus(_ status: BtnStatus, btn: UIButton) {
        switch status {
        case .enable:
            btn.isUserInteractionEnabled = true
            btn.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        case .disable:
            btn.isUserInteractionEnabled = false
            btn.backgroundColor =  UIColor(hexString: "999999")
        }
    }
    
    func updateCheckoutBtnStatus() {
        if let paymentInfoCell = checkoutTableView.cellForRow(
            at: IndexPath(row: 0, section: 2)) as? STPaymentInfoTableViewCell {
            
            setBtnStatus(userPersonalInfoIsFinished && paymentInfoIsFinished ? .enable : .disable,
                         btn: paymentInfoCell.checkBtn)
        }
    }
    
    func gettpdFromPrime(tpdForm: TPDForm) {
        
        tpdForm.onFormUpdated({ (status) in
            if status.isCanGetPrime() {
                
                self.paymentInfoIsFinished = true
                
                print("Yes!!!!!!!")
                
                let tpdCard = TPDCard.setup(tpdForm)
                tpdCard.onSuccessCallback { (prime, _, _) in
                    
                    self.getPrime = prime
                    
                    print("Prime : \(prime!)")
                    
                    }.onFailureCallback { (status, message) in
                        
                        print("status : \(status) , Message : \(message)")
                        
                    }.getPrime()
                
            } else {
                print("Error")
            }
        })
        
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
        ) {
        
        if payment == "貨到付款" {
            paymentInfoIsFinished = true
        } else {
            paymentInfoIsFinished = false
        }
        
        print(payment, cardNumber, dueDate, verifyCode)
    }
    
    func checkout(_ cell: STPaymentInfoTableViewCell) {
        
        // 判斷是否登入過
        if LoginAPI().keyChain["tokenKey"] == nil {
            if let loginVC = storyboard?.instantiateViewController(
                withIdentifier: "FBLoginViewController") as? FBLoginViewController {
                loginVC.modalPresentationStyle = .overCurrentContext
                present(loginVC, animated: false)
            }
            return
        }
        
        if cell.paymentTextField.text == "貨到付款" {
            
            if let checkoutResultVC = storyboard?.instantiateViewController(
                withIdentifier: "checkoutResultVC") as? CheckoutResultViewController {
                navigationController?.pushViewController(checkoutResultVC, animated: true)
            }
            return
        } else {
        
        guard let userInfoData = userInfo, let getPrime = getPrime else { return }
        
        let orderData = Order(
            stbtotal: calculationItemprice(),
            freight: 60,
            total: calculationItemNum(),
            recipient: userInfoData,
            productlist: products)
        
        let orderResult = Result(prime: getPrime, order: orderData)
        let payCheck = PayCheckAPI()
            
            payCheck.checkPrimeInfo(result: orderResult)
            
            if let checkoutResultVC = storyboard?.instantiateViewController(
                withIdentifier: "checkoutResultVC") as? CheckoutResultViewController {
                navigationController?.pushViewController(checkoutResultVC, animated: true)
            }
        }
    }
}
