//
//  Passdata.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
class PassData() {
    
    let listVc = storyboard?.instantiateViewController(withIdentifier: "pageInfoController") as? PageInfoController
    let getData = listInfo[indexPath.row]
    listVc?.productTitl = getData.title
    listVc?.priceText = getData.price
    listVc?.idNumber = getData.id
    listVc?.descText = getData.story
    listVc?.infoText = getData.note
}
