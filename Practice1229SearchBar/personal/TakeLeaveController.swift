//
//  TakeLeaveController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class TakeLeaveController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    fileprivate lazy var dateFormatterS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        return formatter
    }()
    
    static var selectedDate : String?
    static var dateID : Int?
    static var selectedScheduleID : Int?
    static var deputyID : Int?
    
    let shiftPicker = UIPickerView()
    let alterPicker = UIPickerView()
    
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_shift: UITextField!
    @IBOutlet weak var tf_deputy: UITextField!
    @IBAction func btn_confirm(_ sender: RoundRecButton) {
        if tf_date.text == "" || tf_shift.text == "" || tf_deputy.text == "" {
            Toast.showToast(self.view, "請完整填寫資訊")
        }else{
            searchSchedulebydateAPI()
            getStaffIDAPI()
            //還差時間的參數
//            getScheduleIDAPI()
            
            let controller1 = UIAlertController(title: "確認送出？", message: "請確認資訊正確", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "沒問題", style: .default) { (_) in
                
                let time = self.dateFormatterS.string(from: Date())
                NetWorkController.sharedInstance.postT(api: "/leave/leaveneeddeputy", params: ["ltdScheduleID": TakeLeaveController.selectedScheduleID, "time": time, "deputyID": TakeLeaveController.deputyID, "approverLtdID": Global.companyInfo?.ltdID])
                {(jsonData) in
                    
                    if TakeLeaveController.selectedScheduleID != nil, TakeLeaveController.dateID != nil, ((Global.companyInfo?.ltdID) != nil) {
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
    }
    
//    func getScheduleIDAPI(){
//        //獲得Schedule ID
//        let date1 = TakeLeaveController.selectedDate.components(separatedBy: "-")
//        let year = date1[0]
//        let month = date1[1]
//        let api2 = "/search/preschedule/" + year + "/" + month + "/"
//        NetWorkController.sharedInstance.get(api: api2){(jsonData) in
//            if jsonData["Status"].string == "200"{
//                let arr = jsonData["rows"]
//                for i in 0 ..< arr.count{
//                    let companyJson = arr[i]
//                    let date = companyJson["date"].string
//                    if date == TakeLeaveController.self.selectedDate{
//                        let ltdScheduleID = companyJson["ltdScheduleID"].int
//                        TakeLeaveController.selectedScheduleID = ltdScheduleID
//                        print("TakeLeaveController.selectedScheduleID \(TakeLeaveController.selectedScheduleID)")
//                    }
//                }
//            }
//        }
//    }
    
    func getStaffIDAPI(){
        NetWorkController.sharedInstance.get(api: "/search/staffinfobycompany")
        {(jsonData) in
            
            if jsonData["Status"].string == "200"{

                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let staffName = companyJson["staffName"].string
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
            b += "/search/schedulebydate/\(TakeLeaveController.self.dateID!)/\(abs)"
        }
        NetWorkController.sharedInstance.get(api: b)
        {(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let ltdScheduleID = companyJson["ltdScheduleID"].int
                    if ltdScheduleID == TakeLeaveController.selectedScheduleID{
                        TakeLeaveController.selectedScheduleID = ltdScheduleID
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        view.setNeedsDisplay()
        setDefaultData()
        print("view did load")
//        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
//    @objc func disconnectPaxiSocket(_ notification: Notification) {
//        setDefaultData()
//    }
    
    //居然有用啊幹
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        view.setNeedsDisplay()
//        setDefaultData()
//        print("view will appear")
//    }
    
    
    func setDefaultData(){
//        print("1ww" + TakeLeaveController.selectedDate)
//        print("hi \(tf_date.text)")
        tf_date.text = TakeLeaveController.selectedDate

        tf_shift.text = Global.shiftDateNames[0]
        tf_deputy.text = "Arumin" // 給定目前可選擇員工的第一個員工
        tf_date.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        
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
        alterPicker.dataSource = self
        alterPicker.delegate = self
                        
        //讓textfiled的輸入方式改為pickerView
        tf_shift?.inputView = self.shiftPicker
        tf_deputy.inputView = self.alterPicker
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
                return Global.shiftDateNames.count
            }
        }else{
            if component == 0{
                return Global.shiftDateNames.count //需要改成目前可選擇員工的array
            }
        }
        return 0
    }
    
    //設定資料的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.shiftPicker{
            if component == 0{
                return Global.shiftDateNames[row]
            }}else{
            if component == 0{
                return Global.shiftDateNames[row]//需要改成目前可選擇員工的array
            }
        }
        return nil
    }

    //定義選取後的行為
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int){
        if pickerView == self.shiftPicker{
        if component == 0{
            tf_shift?.text = Global.shiftDateNames[row]
        }
        }else{
            if component == 0{
                tf_deputy?.text = Global.shiftDateNames[row]//需要改成目前可選擇員工的array
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
}

