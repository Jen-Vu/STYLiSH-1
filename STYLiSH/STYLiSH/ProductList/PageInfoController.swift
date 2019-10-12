//
//  UIPageController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class PageInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listInfoTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let infoCell = tableView.dequeueReusableCell(
            withIdentifier: "descriptionCell", for: indexPath) as? ProductDescriptionCell {
            
            infoCell.backgroundColor = .blue
            
            return infoCell
        }
        return UITableViewCell()
        
//        guard  let else { return UITableViewCell()}
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return PageInfoFooterView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       navigationController?.setNavigationBarHidden(true, animated: true)
        listInfoTableView.delegate = self
        listInfoTableView.dataSource = self
    }
}
