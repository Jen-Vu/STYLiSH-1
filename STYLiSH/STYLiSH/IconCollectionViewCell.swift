//
//  IconCollectionViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/14.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

struct IconInfo {
    let image: String
    let text: String
}

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    
    func showIconSection(image: String, text: String) {
        iconImage.image = UIImage(named: image)
        iconLabel.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        iconLabel.text = text
    }
    
}
