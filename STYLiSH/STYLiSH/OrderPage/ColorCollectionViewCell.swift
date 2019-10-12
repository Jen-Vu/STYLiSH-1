//
//  ColorCollectionViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var choseColorView: UIView!
    
    func showChoseColors(colorCode: String) {
        choseColorView.backgroundColor = UIColor(hexString: "#\(colorCode)")
       choseColorView.layer.borderWidth = 0.5
        choseColorView.layer.borderColor = UIColor(hexString: "#\(888888)").cgColor
    }
    
}
