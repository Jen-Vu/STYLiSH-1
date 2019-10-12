//
//  Item2TableViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher

class HotOddTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
        let lefturl = URL(string: product.images[0])
       leftImage.kf.setImage(with: lefturl)
        let topurl = URL(string: product.images[1])
        topImage.kf.setImage(with: topurl)
        let buttonurl = URL(string: product.images[2])
        buttonImage.kf.setImage(with: buttonurl)
        let righturl = URL(string: product.images[3])
        rightImage.kf.setImage(with: righturl)
        
        titleLabel.text = product.title
        descLabel.text = product.description
    }

}
