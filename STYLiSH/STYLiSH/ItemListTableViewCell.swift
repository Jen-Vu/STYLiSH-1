//
//  itemListTableViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/15.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher

class ItemListTableViewCell: UITableViewCell {
   
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupViewWith(image: String, title: String, price: Int) {
        let url = URL(string: image)
        productImage.kf.setImage(with: url)
        productNameLabel.text = title
        priceLabel.text = "NT $ \(price)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
