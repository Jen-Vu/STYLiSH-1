//
//  ProductInfoColorCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProductInfoColorCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var showColors: [String] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var showColorCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showColors.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let colorCell = showColorCollection.dequeueReusableCell(
            withReuseIdentifier: "showColor", for: indexPath) as? CollectionViewCell {
            
            colorCell.showProductColor(color: showColors[indexPath.row])
    
            return colorCell
        }
        return UICollectionViewCell ()
    }
    
    func setupView(showColor: [String]) {
        
        showColorCollection.delegate = self
        showColorCollection.dataSource = self
        showColorCollection.reloadData()
         titleLabel.text = NSLocalizedString("Color", comment: "")
        showColors = showColor
      
    }
 
}
