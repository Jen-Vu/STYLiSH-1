//
//  CollectionViewCell.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

extension UIColor {
    //swiftlint: disable identifier_name
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let rColor = Int(color >> 16) & mask
        let gColor = Int(color >> 8) & mask
        let bColor = Int(color) & mask
        let red   = CGFloat(rColor) / 255.0
        let green = CGFloat(gColor) / 255.0
        let blue  = CGFloat(bColor) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    func toHexString() -> String {
        var rColor: CGFloat = 0
        var gColor: CGFloat = 0
        var bColor: CGFloat = 0
        var alpah: CGFloat = 0
        getRed(&rColor, green: &gColor, blue: &bColor, alpha: &alpah)
        let rgb: Int = (Int)(rColor*255)<<16 | (Int)(gColor*255)<<8 | (Int)(bColor*255)<<0
        return String(format: "#%06x", rgb)
    }
}
    //swiftlint: eable identifier_name

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showImage: UIView!
    
    func showProductColor(color: String) {
        
        showImage.backgroundColor = UIColor(hexString: "#\(color)")
    }
    
}
