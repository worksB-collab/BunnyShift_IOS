//
//  TakeLeaveController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class TakeLeaveController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        return formatter
    }()
    
    fileprivate lazy var dateFormatterS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        return formatter
    }()
    
    static var selectedDate : String?
    static var dateID : Int?
    static var selectedScheduleID : Int?
    static var deputyID : Int?
    var deputyArr = Array<String>()
    var shiftArr = Array<String>()
    
    let shiftPicker = UIPickerView()
    let deputyPicker = UIPickerView()
    
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_shift: UITextField!
    @IBOutlet weak var tf_deputy: UITextField!
    @IBAction func btn_confirm(_ sender: RoundRecButton) {
        if tf_date.text == "" || tf_shift.text == "" || tf_deputy.text == "" {
            Toast.showToast(self.view, "請完整填寫資訊")
        }else{
            sendOutApplication()
        }
    }
    
    func sendOutApplication(){
        getStaffIDAPI()
        let controller1 = UIAlertController(title: "確認送出？", message: "請確認資訊正確", preferredStyle: .alert)
        controller1.setTint(color: UIColor(named: "Color3")!)
        let okAction = UIAlertAction(title: "沒問題", style: .default) { (_) in
            if TakeLeaveController.selectedScheduleID == nil || Global.companyInfo?.ltdID == nil {
                Toast.showToast(self.view, "資料不完整")
                return
            }else if  self.tf_deputy.text == "無人可代班" {
                Toast.showToast(self.view, "目前無人可協助代班")
                return
            }else if  self.tf_shift.text == "無需代班" {
                Toast.showToast(self.view, "你沒有上今天的班喔")
                return
            }
            
            let time = self.dateFormatterS.string(from: Date())
            NetWorkController.sharedInstance.postT(api: "/leave/leaveneeddeputy", params: ["ltdScheduleID": TakeLeaveController.selectedScheduleID, "time": time, "deputyID": TakeLeaveController.deputyID, "approverLtdID": Global.companyInfo?.ltdID])
            {(jsonData) in
                
                if jsonData["Status"].string == "200"{
                    print("xx? ltdScheduleID \( TakeLeaveController.selectedScheduleID) time\( time)deputyID \(TakeLeaveController.deputyID) approverLtdID \(Global.companyInfo?.ltdID))")
                    
                    Toast.showToast(self.view, "已成功送出申請")
                    
                    self.dismiss(animated: true, completion: nil)
                }else{
                    Toast.showToast(self.view, jsonData["message"].string!)
                }
                
            }
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
    }
    
    func getStaffIDAPI(){
        NetWorkController.sharedInstance.get(api: "/search/staffinfobycompany")
        {(jsonData) in
            
            if jsonData["Status"].string == "200"{

                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let staffName = companyJson["staffName"].string
                    print("zzz \(staffName) \(self.tf_deputy.text)")
                    if staffName == self.tf_deputy.text{
                        let staffID = companyJson["staffID"].int
                        TakeLeaveController.deputyID = staffID
                        
                    }
                }
            }
        }
    }
    
    func searchSchedulebydateAPI(){
        // get how many shifts and staffs working on certain date
        var b = ""
        if let abs = Global.companyInfo!.ltdID{
            if let dateID = TakeLeaveController.dateID{
                b += "/search/schedulebydate/\(dateID)/\(abs)"
            }
        }
        NetWorkController.sharedInstance.get(api: b)
        {(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let ltdScheduleID = companyJson["ltdScheduleID"].int
                    let timeShiftName = companyJson["timeShiftName"].string
                    if timeShiftName == self.tf_shift.text{
                        TakeLeaveController.selectedScheduleID = ltdScheduleID
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.setNeedsDisplay()
//        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
//    @objc func disconnectPaxiSocket(_ notification: Notification) {
//        setDefaultData()
//    }
    
    //居然有用啊幹（很重要的參考資源，不准刪除）
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        view.setNeedsDisplay()
//        setDefaultData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDateIDAPI()
        setDefaultData()
        setPickerView()
        getStaffIDAPI()
    }
    
    func getDateIDAPI(){
        let date1 = TakeLeaveController.selectedDate!.components(separatedBy: "-")
        let year = date1[0]
        let month = date1[1]
        
        // get dateID
        let api1 = "/search/calendar/" + year + "/" + month
        NetWorkController.sharedInstance.get(api: api1){(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    if companyJson["date"].string == TakeLeaveController.selectedDate{
                        TakeLeaveController.dateID = companyJson["dateID"].int
                        self.searchSchedulebydateAPI()
                    }
                }
            }
        }
    }
    
    func setDefaultData(){
        tf_date.text = TakeLeaveController.selectedDate
        tf_date.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        shiftArr = currentShift()
    }
    
    func currentShift() -> Array<String>{
        
        var a = ""
        if let abs = Global.companyInfo!.ltdID{
            if let dateID = TakeLeaveController.dateID{
                a += "/search/schedulebydate/" + "\(dateID)" + "/\(abs)"
            }
        }
        
        var arrShift = Array<String>()
        NetWorkController.sharedInstance.get(api: a){(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    if let name = Global.staffInfo?.name{
                        if companyJson["date"].string == self.tf_date.text, companyJson["staffName"].string == name{
                            
                            let shift = companyJson["timeShiftName"].string
                            arrShift.append(shift!)
                        }
                    }
                }
                if arrShift.count == 0 {
                    self.tf_shift.text = "無需代班"
                }else{
                    self.tf_shift.text = arrShift[0]
                }
                self.deputyArr = self.freeDeputy()
            }
            self.shiftPicker.reloadAllComponents()
        }
        return arrShift
    }
    
    func freeDeputy() -> Array<String>{
        
        var a = ""
        if let abs = Global.companyInfo!.ltdID{
            if let dateID = TakeLeaveController.dateID{
                a += "/search/schedulebydate/" + "\(dateID)" + "/\(abs)"
            }
        }
        
        var arrStaff = Array<String>()

        NetWorkController.sharedInstance.get(api: a){(jsonData) in
            if jsonData["Status"].string == "200"{
                
                for i in Global.staffList{
                    arrStaff.append(i.name)
                }
                
                let arr = jsonData["rows"]
                var arrCount = arr.count
                for i in 0 ..< arrCount{
                    let companyJson = arr[i]
                    if companyJson["date"].string == self.tf_date.text, companyJson["timeShiftName"].string == self.tf_shift.text{
                        if let name = companyJson["staffName"].string{
                            arrStaff.removeAll { (j) -> Bool in
                                let isRemove = j == name
                                return isRemove
                            }
                            continue
                        }
                        if let name = Global.staffInfo?.name{
                            arrStaff.removeAll { (j) -> Bool in
                                let isRemove = j == name
                                return isRemove
                            }
                        }
                    }
                }
                
                if arrStaff.count == 0 {
                    self.tf_deputy.text = "無人可代班"
                }else{
                    self.tf_deputy.text = arrStaff[0]
                }
            }
            self.deputyPicker.reloadAllComponents()
        }
        return arrStaff
        
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseDateController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // picker view
    func setPickerView(){
        //設定代理人和資料來源為viewController
        shiftPicker.dataSource = self//告訴pickerView要從哪個view controller中取得要顯示的資料
        shiftPicker.delegate = self //告訴pickerView當使用者選了選項後 要讓哪一個view controller知道使用者的選擇
        deputyPicker.dataSource = self
        deputyPicker.delegate = self
                        
        //讓textfiled的輸入方式改為pickerView
        tf_shift?.inputView = self.shiftPicker
        tf_deputy.inputView = self.deputyPicker
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
     //有幾個滾輪
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //每個滾輪有幾筆資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //0代表最左邊的滾輪
        if pickerView == self.shiftPicker{
            if component == 0{
                return shiftArr.count
            }
        }else{
            if component == 0{
                return deputyArr.count //需要改成目前可選擇員工的array
            }
        }
        return 0
    }
    
    //設定資料的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.shiftPicker{
            if component == 0{
                return shiftArr[row]
            }}else{
            if component == 0{
                return deputyArr[row]//需要改成目前可選擇員工的array
            }
        }
        return nil
    }

    //定義選取後的行為
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int){
        if pickerView == self.shiftPicker{
            if component == 0{
                if shiftArr.count != 0{
                    tf_shift?.text = shiftArr[row]
                    getDateIDAPI()
                }
            }
        }else{
            if component == 0{
                if deputyArr.count != 0{
                    tf_deputy?.text = deputyArr[row]//需要改成目前可選擇員工的array
                    getStaffIDAPI()
                }
            }
        }
    }
    
    //監聽tap鍵盤的事件 -> 點擊螢幕關閉pickerView
    // An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    //按下return接續到下一個textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == tf_date {
         textField.resignFirstResponder()
         tf_shift.becomeFirstResponder()
      } else if textField == tf_shift {
        textField.resignFirstResponder()
        tf_deputy.becomeFirstResponder()
      }else if textField == tf_deputy {
         textField.resignFirstResponder()
      }
     return true
    }
    
    

}

// 鍵盤出現時view往上移動
extension TakeLeaveController: UITextFieldDelegate {
    /// 開始輸入
    ///
    /// - Parameter textField: _
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
           self.view.frame.origin.y = -50
        })
        
    }

    /// 結束輸入
    /// - Parameter textField: _
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setDefaultData()
        setPickerView()
    }
}

