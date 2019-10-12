## Pass Data
###### 1. How does we pass data from cell to view controller? Please decribe the whole porcess step by step.
    1. 宣告一個 protocol delegate，定義要傳送的 data 資料跟要實作的 func
````swift
protocol STOrderUserInputCellDelegate: AnyObject {
    func didChangeUserData(
    ...
    )
    }
````
    2. 並新增一個型別為此 protocol 的變數  
````swift
weak var delegate: STOrderUserInputCellDelegate?
````
    3. 設定要實作這個 delegate 的代理人 > VC，並且要遵從這個 protocol 要實作的 func

######  2. When did you trigger the action for pass data? For what reason you design the process like this?
    在使用者輸入完資料後觸發，
    在此時觸發即可接收到使用者輸入後的資料。

## UITableView

###### 1. The section header usually sticked on the top of the table view when the section contents are visible. How do we make the header do not stick on the top of the screen even if the section contents are still visible. 
    將 TableView 調整為已 Grouped 的方式顯示
    但群組的方式顯示會讓每個 section 的間隔會差距較遠，需再調整 Header＆Footer 的高度。

######  2. UITableView has a default seperated line below each cell, how do we remove it?
    將 TableView 的屬性 Separator 設定為 none
    tableView.separatorStyle = .none
    
######  3. If the auto layout inside the cell has changed, we should we do so that the iOS system will update the app's view.(信用卡與貨到付款切換的時候，cell 畫面會有變化) 
    在切換狀態時要重新 reloadData ，讓 cell 內的內容做改變。

## UISegmentedControl

###### 1.  How does we change UISegmentedControl's color? Which property should we modify?
    可以使用 tintColor 改改變選取時的顏色。

###### 2.  Which property should we modify for controling segment count?
    numberOfSegments 可以定義 segment 的數量。

###### 3.  If we want to trigger an action when user tap the segmented control element, which control event should we choose?
    UISegmentedControl
    1.使用 storyboard 建立IBAction
    2.segment.addTarget(self, action: #selector(changeValue), for: .valueChanged)

## UITextField

###### 1.  How do we change the text inset of UITextField?
    覆寫 textRect 的方法，可以自定義 textRect 與 editingRect 的邊界。
```swift
override func textRect(forBounds bounds: CGRect) -> CGRect {
return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
}
```

###### 2.  Which porperty can control the keyboard type of UITextField?
    textField.keyboardType = .numberPad 此屬性可以設置要改變的鍵盤樣式

###### 3.  How to remove the default border line for UITextField?
    改變 textField boderStyle 的屬性。
    textField.borderStyle = UITextBorderStyleNone

###### 4.  How do we make the UIPikcerView as the UITextField's keyboard?
    需宣告一個 pikerView，將 pikerView 放入 textFieldView內
```swift
let shipPicker = UIPickerView()
paymentTextField.inputView = shipPicker
```
###### 5.  How do we know user finish edit on a UITextField?
```swift
func textFieldDidEndEditing(_ textField: UITextField) {

}
```


## UIPickerView

###### 1.  How to create a picker view?
````swift
class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

let picker = UIPickerView()

override func viewDidLoad() {
super.viewDidLoad()
picker.delegate = self
picker.dataSource = self
}

func numberOfComponents(in pickerView: UIPickerView) -> Int {
return 1 // 有幾列可以選擇
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
return 2 //各列有多少行資料
}

}
````
###### 2.  How to set the content of a UIPickerView?
````swift
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
if row == 0 {
return "one"
}
return "two"
}
````
