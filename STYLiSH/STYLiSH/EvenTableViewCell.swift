//
//  ItemTableViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher

class EvenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupViewWith(product: Product) {
        let  url = URL(string: product.mainImage)
        itemImage.kf.setImage(with: url)
        titleLable.text = product.title
        descLabel.text = product.description
    }
}
