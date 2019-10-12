//
//  OrderViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import IQKeyboardManager
import CoreData

enum BtnStatus {
    case enable
    case disable
}

class OrderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var addCarBtn: UIButton!
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var choseColor: UILabel!
    @IBOutlet weak var choseSizes: UILabel!
    @IBOutlet weak var choseNum: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var numTextField: UITextField!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    var getOrderData: Product?
    // MARK: - 設置 collectionCell 內容
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let getOrderData = getOrderData else { return 0}
        if collectionView == colorCollectionView {
            return getOrderData.colors.count
        } else if collectionView == sizeCollectionView {
            return getOrderData.sizes.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let getOrderData = getOrderData  else { return UICollectionViewCell() }
        
        if collectionView == colorCollectionView {
            guard let colorCell = colorCollectionView.dequeueReusableCell(
                withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
                else { return UICollectionViewCell() }
            
            colorCell.showChoseColors(colorCode: getOrderData.colors[indexPath.row].code)
            
            return colorCell
            
        } else if collectionView == sizeCollectionView {
            guard let sizeCell = sizeCollectionView.dequeueReusableCell(
                withReuseIdentifier: "sizeCell", for: indexPath) as? SizesCollectionViewCell
                else { return UICollectionViewCell() }
            
            sizeCell.showSize(text: getOrderData.sizes[indexPath.row])
            return sizeCell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    // MARK: - 選取 collectionCell 的動作
    
    var currentColorSelect: Int?
    
    var currentSizeSelect: Int?
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == sizeCollectionView {
            
            return currentColorSelect != nil
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case colorCollectionView:
            let colorcell = colorCollectionView.cellForItem(at: indexPath)
            colorcell?.layer.borderColor = UIColor.black.cgColor
            colorcell?.layer.borderWidth = 1.5
            currentColorSelect = indexPath.row
            
        case sizeCollectionView:
            
            let sizeCell = sizeCollectionView.cellForItem(at: indexPath)
            sizeCell?.layer.borderColor = UIColor.black.cgColor
            sizeCell?.layer.borderWidth = 1.5
            currentSizeSelect = indexPath.row
            
        default:
            break
        }
        
        if let currentColorSelect = currentColorSelect, let currentSizeSelect = currentSizeSelect {
            let getStockNum = getOrderData?.variants.filter({ (variant) -> Bool in
                variant.colorCode == getOrderData?.colors[currentColorSelect].code &&
                    variant.size == getOrderData?.sizes[currentSizeSelect]
            }).first
            
            let stockNum = getStockNum?.stock
            stockLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("stockNum", comment: ""), stockNum ?? 0)
            stockLabel.isHidden = false
            stockCurrentNum = stockNum ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case colorCollectionView:
            let colorcell = colorCollectionView.cellForItem(at: indexPath)
            colorcell?.layer.borderColor = UIColor.clear.cgColor
            
        case sizeCollectionView:
            let sizeCell = sizeCollectionView.cellForItem(at: indexPath)
            sizeCell?.layer.borderColor = UIColor.clear.cgColor
        default:
            break
        }
    }
    
    // MARK: - set btnStatus
    func btnStatus(_ btn: UIButton, _ status: BtnStatus) {
        
        switch status {
        case .enable:
            btn.isUserInteractionEnabled = true
            btn.alpha = 1
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            numTextField.isUserInteractionEnabled = true
        case .disable:
            btn.isUserInteractionEnabled = false
            btn.alpha = 0.3
            btn.layer.borderWidth = 1
        }
    }
    
    // MARK: - set NumSelectBtn
    
    @IBOutlet weak var addNumBtn: UIButton!
    @IBOutlet weak var subtractNumBtn: UIButton!
    
    var stockCurrentNum: Int = 0 {
        
        didSet {
            
            numSelected = 0
        }
    }
    
    var numSelected: Int = 0 {
        
        didSet {
            numTextField.text = String(numSelected)

            if stockCurrentNum > numSelected {
                btnStatus(addNumBtn, .enable)
                numTextField.alpha = 1

            } else {
                btnStatus(addNumBtn, .disable)
                numTextField.alpha = 0.3

            }

            if numSelected != 0 {
                btnStatus(subtractNumBtn, .enable)
                btnStatus(addCarBtn, .enable)
                numTextField.alpha = 1

            } else {
                btnStatus(subtractNumBtn, .disable)
                btnStatus(addCarBtn, .disable)
            }
        }
    }
    
    @IBAction func clickAddBtn(_ sender: Any) {
        numSelected += 1
    }
    
    @IBAction func clickSubtractBtn(_ sender: Any) {
        numSelected -= 1
    }
    
    // MARK: - 設置 setAddCarBtn
    
    func setAddCarBtn() {
        addCarBtn.setTitle(NSLocalizedString("addtoCart", comment: ""), for: .normal)
        addCarBtn.setTitleColor(.white, for: .normal)
        addCarBtn.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
       
    }
    
    @IBAction func clickAddCarBtn(_ sender: Any) {
        let alert = UIAlertController(
            title: NSLocalizedString("Success", comment: ""),
            message: "Success",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "close", style: .default) { (_) in
           self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        viewBackground.isHidden = true
        addOrderData()
        
    }
    
     // MARK: - Add 資料進入 CoreData 
    func addOrderData() {
        
        let saveObject = AddCarInfo(context: StorageManager.shared.persistentContainer.viewContext)
        
        saveObject.title = getOrderData?.title
        saveObject.image = getOrderData?.mainImage
        saveObject.price = Int16(getOrderData?.price ?? 0)
        saveObject.colorCode = getOrderData?.colors[currentColorSelect ?? 0].code
        saveObject.size = getOrderData?.sizes[currentSizeSelect ?? 0]
        saveObject.selectNum = Int16(numSelected)
        saveObject.colorName = getOrderData?.colors[currentColorSelect ?? 0].name
        saveObject.id = String(getOrderData?.id ?? 0)

        print(saveObject.selectNum)
        
        StorageManager.shared.saveContext()
    }
    
    // MARK: - 設置 numTextField
    func numTextFieldLayuot() {
        numTextField.alpha = 0.3
        numTextField.layer.borderWidth = 1
        numTextField.layer.borderColor = UIColor.black.cgColor
        numTextField.isUserInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var textNum = 0
        textNum = Int(textField.text ?? "0") ?? 0
        
        if textNum <= stockCurrentNum {
            numSelected = textNum
        } else {
            numSelected = stockCurrentNum
        }
    }
    
    // MARK: - 設置 Layout
    
    func setLayout() {
        if let getOrderData = getOrderData {
            productTitle.text = getOrderData.title
            productPrice.text = "NT $ \(String(getOrderData.price))"
        }
        stockLabel.isHidden = true
        choseColor.text = NSLocalizedString("ChoseColor", comment: "")
        choseSizes.text = NSLocalizedString("ChoseSize", comment: "")
        choseNum.text = NSLocalizedString("ChoseNum", comment: "")
        
    }
    
    // MARK: - 返回 ListPage
    var viewBackground = UIView()
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        viewBackground.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        setAddCarBtn()
        setLayout()
        
        IQKeyboardManager.shared().isEnabled = true
        
        numTextField.text = "0"
        btnStatus(addNumBtn, .disable)
        btnStatus(subtractNumBtn, .disable)
        btnStatus(addCarBtn, .disable)
        numSelected = 0
        numTextFieldLayuot()
        numTextField.delegate = self
    
    }
    
}
