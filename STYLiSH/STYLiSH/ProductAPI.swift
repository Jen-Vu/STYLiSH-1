//
//  ProductListAPI.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/16.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

// MARK: - MarketManager
protocol MarketManagerDelegate: class {
    
    func manager(_ manager: MarketManager, didGet marketingHots: [Hots])
    
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    
    weak var delegate: MarketManagerDelegate?
    
    func getMarketingHots() {
        
        let urlStr = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            //            request.httpBody =
            //            request.allHTTPHeaderFields =
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let dataInfo = data else { return }
                //                print("Data:\(data)")
                
                let decoder  = JSONDecoder()
                do {
                    let dataobject = try decoder.decode(Data.self, from: dataInfo)
                    //                    print(dataobject.data[0].title)
                    //                    print(dataobject.data[0].products[1].sizes)
                    //
                    self.delegate?.manager(self, didGet: dataobject.data )
                    
                } catch {
                    print(error)
                    
                }
                } .resume()
        }
    }
}

// MARK: - ProductListAPI
protocol ProducListDelegate: class {

func manager(_ manager: ProductListAPI, didGet marketingListData: List)

func manager(_ manager: ProductListAPI, didFailWith error: Error)
}

class ProductListAPI {
    let baseURL = "https://api.appworks-school.tw/api/1.0"
    
    enum Endpoint: String {
        case womenEndpoint = "/products/women"
        case menEndpoint = "/products/men"
        case accessoriesEndpoint = "/products/accessories"
    }
    
    weak var listDelegate: ProducListDelegate?
    
    func getProducts(for category: ListCategory, paging: Int) {
        let completeURL: String
        
        switch category {
        case .women:
            completeURL = baseURL + "\(Endpoint.womenEndpoint.rawValue)" + "?paging=\(String(paging))"
        case.men:
            completeURL = baseURL + "\(Endpoint.menEndpoint.rawValue)" + "?paging=\(String(paging))"
        case.accessories:
            completeURL = baseURL + "\(Endpoint.accessoriesEndpoint.rawValue)" + "?paging=\(String(paging))"

        }

        print(completeURL)
        
        AF.request(completeURL, method: .get).responseJSON { (reponse) in

            guard let productListInfo = reponse.data else { return }
//            print(String(data: productListInfo, .utf8))
//            print(String(data: productListInfo, encoding: .utf8))
            let decoder = JSONDecoder()
            do {
                let info = try decoder.decode(List.self, from: productListInfo)
                print("呼叫 API!")

                self.listDelegate?.manager(self, didGet: info)
            } catch {
                print("error")
            }
        }
    }
}

// MARK: - LoginAPI
class LoginAPI {
    
    let keyChain = Keychain()
    
    func getUserLoginInfo(token: String) {
        
        let baseURL = "https://api.appworks-school.tw/api/1.0"
        let endPoint = "/user/signin"
        
        guard let completeURL = URL(string: "\(baseURL + endPoint)") else { return }
        
        var request = URLRequest(url: completeURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        var jason = ["provider": "facebook"]
        jason["access_token"] = token
        
        let jasonData = try? JSONSerialization.data(withJSONObject: jason)
        request.httpBody = jasonData
        
        //Send Request
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            
            guard let dataInfo = data else { return }
            
            let decoder  = JSONDecoder()
            do {
                let dataobject = try decoder.decode(SingIn.self, from: dataInfo)
                self.keyChain["tokenKey"] = dataobject.data.token
                
                let userInfo = dataobject.data.user
                print("id: \(userInfo.id)")
                print("name: \(userInfo.name)")
                print("email: \(userInfo.email)")
                
            } catch {
                print("\(error)=======")
            }
            
            }.resume()
    }
}
// MARK: - PayCheckAPI
class PayCheckAPI {
    
    func checkPrimeInfo(result: Result) {
        
        let baseURL = "https://api.appworks-school.tw/api/1.0"
        let endPoint = "/order/checkut"
        
        guard let completeURL = URL(string: "\(baseURL + endPoint)") else { return }
        
        var request = URLRequest(url: completeURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        let encoder = JSONEncoder()
        
        do {
            let dataobject = try encoder.encode(result)
            request.httpBody = dataobject
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                guard let httpReponse = response as? HTTPURLResponse else { return }
                
                let statusCode = httpReponse.statusCode
                
                if statusCode >= 200 && statusCode < 300 {
                    
                    let json = try? JSONSerialization.jsonObject(
                        with: data, options: .allowFragments) as? [String: Any]
                    
                    print(json!)
                    print(statusCode)
                }
                }.resume()
            
        } catch {
            print(error)
        }
        
    }
    
}
