//
//  listCollectionViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher

struct ListInfo {
    let image: String
    let text: String
}

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func showListInfo(image: String, text: String, desc: String) {
        let  url = URL(string: image)
        itemImage.kf.setImage(with: url)
        titleLable.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        titleLable.text = text
        descLabel.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        descLabel.text = desc
    }
}
