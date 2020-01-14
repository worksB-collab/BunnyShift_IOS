//
//  TakeLeaveController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class TakeLeaveController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let shiftPicker = UIPickerView()
    let alterPicker = UIPickerView()
    
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_shift: UITextField!
    @IBOutlet weak var tf_alter: UITextField!
    @IBAction func btn_confirm(_ sender: RoundRecButton) {
        if tf_date.text == "" || tf_shift.text == "" || tf_alter.text == "" {
            Toast.showToast(self.view, "請完整填寫資訊")
        }else{
            let controller1 = UIAlertController(title: "確認送出？", message: "請確認資訊正確", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "沒問題", style: .default) { (_) in
                
                NetWorkController.sharedInstance.post(api: "/someAPI", params: ["date": self.tf_date.text, "shift": self.tf_shift.text, "alter": self.tf_alter.text, "ltdID": Global.comapanyID])
                {(jsonData) in
                    
                    if true {
//                        self.dismiss(animated: true, completion: nil)
                    }else{
                        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        setDefaultData()
        // Do any additional setup after loading the view.
    }
    
    func setDefaultData(){

        tf_shift.text = Global.shiftDateNames[0]
        tf_alter.text = "Arumin" // 給定目前可選擇員工的第一個員工
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
        tf_alter.inputView = self.alterPicker
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
                tf_alter?.text = Global.shiftDateNames[row]//需要改成目前可選擇員工的array
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
        tf_alter.becomeFirstResponder()
      }else if textField == tf_alter {
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
