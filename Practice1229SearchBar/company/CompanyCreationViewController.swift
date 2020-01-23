//
//  CompanyCreationViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/1.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class CompanyCreationViewController: UIViewController{
    
    @IBOutlet weak var company_tf_account: UITextField!
    @IBOutlet weak var company_tf_password: UITextField!
    @IBOutlet weak var company_tf_name: UITextField!
    @IBOutlet weak var company_tf_phone: UITextField!
    @IBOutlet weak var company_tf_address: UITextField!
    @IBOutlet weak var company_tf_taxID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBOutlet weak var CompanyCreation_confirm: RoundRecButton!
    
    @IBAction func CompanyCreation_confirm(_ sender: UIButton) {
        
        if self.company_tf_account.text == "" || self.company_tf_password.text == "" || self.company_tf_name.text == "" || self.company_tf_phone.text == "" || self.company_tf_address.text == "" || self.company_tf_taxID.text == "" {
            Toast.showToast(self.view, "請完整填寫空白處")
            return
        }
        
        let controller1 = UIAlertController(title: "完成了？", message: "請確認資訊正確", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "沒問題", style: .default) { (_) in
            
            Global.companyInfo = Company(name : self.company_tf_name.text!, number: self.company_tf_phone.text!, address: self.company_tf_address.text!, taxID : self.company_tf_taxID.text!)
            
            NetWorkController.sharedInstance.post(api: "/register/company", params: ["name" : self.company_tf_name.text , "account": self.company_tf_account.text, "password": self.company_tf_password.text, "number": self.company_tf_phone.text, "address": self.company_tf_address.text, "taxID" : self.company_tf_taxID.text])
            {(jsonData) in
                print(jsonData.description)
                if jsonData["Status"].string == "200"{
                    
                    
                    Global.companyInfo = Company(name: self.company_tf_name.text!, number: self.company_tf_phone.text!, address: self.company_tf_address.text!, taxID: self.company_tf_taxID.text!)
                    Global.companyInfo?.account = self.company_tf_account.text
                    Global.companyInfo?.password = self.company_tf_password.text
                    
                    
                    NetWorkController.sharedInstance.post(api: "/login/company", params: ["account": Global.companyInfo?.account, "password": Global.companyInfo?.password]) // 登入ＡＰＩ取得token
                    {(jsonData) in
                        print(jsonData.description)
                        if jsonData["Status"].string == "200"{
                            
                            let token = jsonData["token"].string
                            Global.token = token
                            
                            //希望可以改成直接可以拿到ＩＤ
                            let companyID = jsonData["ltd_id"].int
                            Global.companyInfo!.ltdID = companyID
                            //希望可以改成直接可以拿到ＩＤ
                            
//                            //上面有的話這個就可以刪了
//                            NetWorkController.sharedInstance.get(api: "/search/companyinfo")
//                            {(jsonData) in
//                                let arr = jsonData["rows"]
//                                for i in 0 ..< arr.count{
//                                    let companyJson = arr[i]
//                                    let companyID = companyJson["ltd_id"].int
//                                    Global.companyInfo!.ltdID = companyID
//                                }
//                            }
                        }
                    }
                    self.jumpToNext()
                    
                }else{
                    Toast.showToast(self.view, jsonData.description)
                }
            }
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
        
    }
    // jump to the page we want by its storyBoard ID
    func jumpToNext(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navDateNamingController") 
        present(controller, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == company_tf_account {
            textField.resignFirstResponder()
            company_tf_password.becomeFirstResponder()
        } else if textField == company_tf_password {
            textField.resignFirstResponder()
            company_tf_name.becomeFirstResponder()
        }else if textField == company_tf_name {
            textField.resignFirstResponder()
            company_tf_phone.becomeFirstResponder()
        }else if textField == company_tf_phone {
            textField.resignFirstResponder()
            company_tf_address.becomeFirstResponder()
        }else if textField == company_tf_address {
            textField.resignFirstResponder()
            company_tf_taxID.becomeFirstResponder()
        }else if textField == company_tf_taxID {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
extension CompanyCreationViewController: UITextFieldDelegate {
    /// 開始輸入
    ///
    /// - Parameter textField: _
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = -120
        })
    }
    /// 結束輸入
    ///
    /// - Parameter textField: _
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = 0
        })
    }
}
