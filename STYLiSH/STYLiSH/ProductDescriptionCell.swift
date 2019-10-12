//
//  ProductInfoTableViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showInfo(titleText: String, priceText: Int, idNumber: Int, descText: String) {
        
        titleLabel.text = titleText
        priceLabel.text = "NT$\(priceText)"
        idLabel.text = "\(idNumber)"
        descriptionLabel.text = descText
        
    }

}
