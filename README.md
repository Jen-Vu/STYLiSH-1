<img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/Artboard.png" width="100" height="100"/>

# STYLiSH

專為衣服飾品設計的電商 App

## 功能

### 熱門商品
* 使用 UITableView 並針對不同圖片數量顯示不同的 cell
* 使用 iOS 原生的 URLSession 傳輸網路資料
```swift
func getMarketingHots() {
        
        let urlStr = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let dataInfo = data else { return }
                
                let decoder  = JSONDecoder()
                do {
                    let dataobject = try decoder.decode(Data.self, from: dataInfo)
                    self.delegate?.manager(self, didGet: dataobject.data )
                    
                } catch {
                    print(error)
                    
                }
                } .resume()
        }
    }
```
* 運用第三方套件 **Kingfisher** 處理網路照片
```swift
    func setupViewWith(product: Product) {
        let  url = URL(string: product.mainImage)
        itemImage.kf.setImage(with: url)
    }
```
<img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/HotPage.png" width="180" height="360"/>

### 商品清單
* 切換 UITableView 與 UICollectionView 的顯示方式
* 使用第三方套件 **Alamofire** 處理網路資料
```swift
        AF.request(completeURL, method: .get).responseJSON { (reponse) in

            guard let productListInfo = reponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let info = try decoder.decode(List.self, from: productListInfo)
                self.listDelegate?.manager(self, didGet: info)
            } catch {
            }
        }
```
* 引用第三方套件 **CRRefresh** 處理下拉更新的功能
```swift
listTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()){
             self.listInfo = [] // listInfo 資料清除
            self.paging = 0 // 重置 paging
            self.listTableView.cr.resetNoMore() // 重置 no more data
            //手動下拉refresh ＆ 重新抓資料
            self.productList.getProducts(for: self.listCategory, paging: self.paging)
}
```
<img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/collectionList.png" width="180" height="360"/><img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/tableList.png" width="180" height="360"/>


### 購物清單

* 利用 [Coredata](https://github.com/as462988/STYLiSH/blob/master/STYLiSH/STYLiSH/StorageManager.swift) 存取用戶加入購物車的清單內容
```swift
 func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                 NotificationCenter.default.post(name: notification, object: nil)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
```
* **Push Notification** 在 tabBar 上更新加入購物車的商品數量<br>
` NotificationCenter.default.post(name: notification, object: nil)`<br>
* 針對加減的操作做 cell 的新增與刪除<br>
<img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/cart.png" width="180" height="360"/><img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/Pay.png" width="180" height="360"/>


### 註冊登入
使用 FB Login 作為用戶登入方式，並運用 URLRequest 獲取的 token 存入 keychain 

```swift
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
                
            } catch {
                print("\(error)=======")
            }
            
            }.resume()
    }
}
```
<img src="https://github.com/as462988/STYLiSH/blob/master/screenshot/Login.png" width="180" height="360"/>

### Third-party Libraries
* [Alamofire](https://github.com/Alamofire/Alamofire) - 處理網路資料
* [Kingfisher](https://github.com/onevcat/Kingfisher) - 善用快取的方式處理網路圖片並呈現在 App
* [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) - 藉由將資料存放於 Keychain 中增加隱私資料的安全性
* [FB SDK](https://developers.facebook.com/docs/facebook-login/ios) - 使用 FaceBook 登入與註冊
* [SwiftLint](https://github.com/realm/SwiftLint) - 檢查 codeing Style 的工具
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) - 解決鍵盤彈起時遮住輸入框的工具

## Requirements
* Xcode 10
* iOS 12 SDK <br>
An iPhone running iOS 13.0 A code signing key from Apple is required to deploy apps to a device.
