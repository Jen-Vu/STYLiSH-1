//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/14.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let profileInfo = [
        [
            IconInfo(image: "Icons_24px_AwaitingPayment",
                     text: NSLocalizedString("pendpayment", comment: "")),
            IconInfo(image: "Icons_24px_AwaitingShipment",
                      text: NSLocalizedString("awaitingShipment", comment: "")),
            IconInfo(image: "Icons_24px_Shipped",
                     text: NSLocalizedString("shipped", comment: "")),
            IconInfo(image: "Icons_24px_AwaitingReview",
                     text: NSLocalizedString("awaitingReview", comment: "")),
            IconInfo(image: "Icons_24px_Exchange",
                      text: NSLocalizedString("exchange", comment: ""))
        ],
        [
            IconInfo(image: "Icons_24px_Starred",
                     text: NSLocalizedString("collection", comment: "")),
            IconInfo(image: "Icons_24px_Notification",
                     text: NSLocalizedString("deliverynotice", comment: "")),
            IconInfo(image: "Icons_24px_Refunded",
                    text: NSLocalizedString("refund", comment: "")),
            IconInfo(image: "Icons_24px_Address",
                    text: NSLocalizedString("address", comment: "")),
            IconInfo(image: "Icons_24px_CustomerService",
                    text: NSLocalizedString("service", comment: "")),
            IconInfo(image: "Icons_24px_SystemFeedback",
                    text: NSLocalizedString("feedback", comment: "")),
            IconInfo(image: "Icons_24px_RegisterCellphone",
                     text: NSLocalizedString("phone", comment: "")),
            IconInfo(image: "Icons_24px_Settings",
                     text: NSLocalizedString("set", comment: ""))
        ]
    ]
    let itemSize = CGSize(width: 60, height: 51)
    let cellLocation = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileCollectionLayout: UICollectionViewFlowLayout!
    
    // cell 間的高度距離
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {
        return 24
    }
    
    // cell 間的距離
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        let cellLeft = cellLocation.left
        guard section == 1 else {
            return ((UIScreen.main.bounds.width - (cellLeft * 2) - (itemSize.width * 5)) / 4).rounded(.down)
        }
        return ((UIScreen.main.bounds.width - (cellLeft * 2) - (itemSize.width * 4)) / 3).rounded(.down)
        
    }
    
    // section的位置
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
    -> UIEdgeInsets {
        return cellLocation
    }
    
    //cell 的大小
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        return itemSize
    }
    
    // section 數量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return profileInfo.count
    }
    
    // 每一組有幾個 cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileInfo[section].count
    }
    
    // 每個 cell 要顯示的內容
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if
            let iconCell = profileCollectionView.dequeueReusableCell(
                withReuseIdentifier: "iconShow", for: indexPath) as? IconCollectionViewCell {
            let info = profileInfo[indexPath.section][indexPath.row]
            iconCell.showIconSection(image: info.image, text: info.text)
            
            return iconCell
        } 
        return UICollectionViewCell()
    }
    
    // Header
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            // header
           guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath
                ) as? ProfileHeaderView
            else { fatalError( "Invalid view type" ) }
            
            switch indexPath.section {
            case 0:
                headerView.headerLabel.text = NSLocalizedString("order", comment: "")
                headerView.headerBotton.setTitle(
                    NSLocalizedString("allorders", comment: ""), for: .normal)
            case 1:
                headerView.headerLabel.text = NSLocalizedString("moreservices", comment: "")
                headerView.headerBotton.isHidden = true
            default: break
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
}
