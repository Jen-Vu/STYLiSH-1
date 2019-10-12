//
//  TabBarController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/26.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var productCount: [AddCarInfo] = []
        productCount = StorageManager.shared.getAddCarInfos()
        
        self.viewControllers?[2].tabBarItem.badgeValue = String(productCount.count)
        self.viewControllers?[2].tabBarItem.badgeColor = .brown
    }
}
