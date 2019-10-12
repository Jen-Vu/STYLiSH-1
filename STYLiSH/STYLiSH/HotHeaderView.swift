//
//  HotPageView.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/13.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

class HotHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        setupViews(title: title)
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(title: String) {
        titleLabel.text = title
        self.addSubview(titleLabel)
    }
    
    func layoutViews() {
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
}
