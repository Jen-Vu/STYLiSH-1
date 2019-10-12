//
//  ProductListData.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/16.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

struct Data: Codable {
    let data: [Hots]
}
// hotsPage
struct Hots: Codable {
    let title: String
    let products: [Product]
}
// listPage
struct List: Codable {
    let data: [Product]
    let paging: Int?
}

struct Product: Codable {
    let id: Int
    let category: String?
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [Color]
    let sizes: [String]
    let variants: [Variant]
    let mainImage: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, category, title, description, price, texture, wash, place, note, story, colors, sizes, variants, images
        case mainImage = "main_image"
    }
}

struct Color: Codable {
    let code: String
    let name: String
}

struct Variant: Codable {
    let colorCode: String
    let size: String
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size, stock
    }
}

// MARK: - 登入頁面
struct SingIn: Codable {
    let data: UserData
}

struct UserData: Codable {
    let token: String
    let expired: Int
    let user: UserObject

    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case expired = "access_expired"
        case user
    }
}
struct UserObject: Codable {
    let id: Int
    let provider: String
    let name: String
    let email: String
    let picture: String
}

// MARK: - 結帳結果頁面
struct Result: Codable {
    let prime: String
    let order: Order
}

struct Order: Codable {
    let shipping = "delivery"
    let payment = "credit_card"
    let subtotal: Int
    let freight: Int
    let total: Int
    let recipient: Recipient
    let list: [OrderList]
    
    // 將 coreData 的資料存入 OrderList 內
   static func getProductInfo(product: [AddCarInfo]) -> [OrderList] {
        var orderList = [OrderList]()
        
        for product in product {
            let element = OrderList(id: product.id ?? "",
                                    name: product.title ?? "",
                                    price: Int(product.price),
                                    color: Color(code: product.colorCode ?? "FFFFFF",
                                                 name: product.colorName ?? "白色"),
                                    size: product.size ?? "",
                                    qty: Int(product.selectNum))
            orderList.append(element)
            
        }
        print(orderList)
        return orderList
    }
    
    //初始化 建構值
    init(
        stbtotal: Int,
        freight: Int,
        total: Int,
        recipient: Recipient,
        productlist: [AddCarInfo]
        ) {
        self.subtotal = stbtotal
        self.freight = freight
        self.total = total
        self.recipient = recipient
        self.list = Order.getProductInfo(product: productlist)
    }
}

struct Recipient: Codable {
    let name: String
    let phone: String
    let email: String
    let address: String
    let time: String
}

struct OrderList: Codable {
    let id: String
    let name: String
    let price: Int
    let color: Color
    let size: String
    let qty: Int
}
