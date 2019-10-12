//
//  SizesCollectionViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class SizesCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var choseSizeView: UIView!
    @IBOutlet weak var choseSizeLabel: UILabel!
    
    func showSize(text: String) {
        choseSizeView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        choseSizeLabel.text = text
        
    }
}
