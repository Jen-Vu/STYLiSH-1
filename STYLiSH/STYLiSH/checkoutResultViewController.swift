//
//  checkoutResultViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class CheckoutResultViewController: UIViewController {
    
    var productCart: [AddCarInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("result", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
       
    }
    
    @IBAction func backToHotVC(_ sender: Any) {
        if let tabBarPage = storyboard?.instantiateViewController(
            withIdentifier: "TabBarController") as? TabBarController {
            present(tabBarPage, animated: false, completion: nil)
            productCart = StorageManager.shared.getAddCarInfos()
            let context = StorageManager.shared.persistentContainer.viewContext
            
            for productItem in productCart {
                context.delete(productItem)
            }
            StorageManager.shared.saveContext()
        }
    }

}
