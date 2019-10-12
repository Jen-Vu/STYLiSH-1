//
//  ProductinformationCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProductInforStringCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showInfo(titleText: String, infoText: String ) {
     
        titleLabel.text = titleText
        infoLabel.text = infoText
    
    }
    
}
