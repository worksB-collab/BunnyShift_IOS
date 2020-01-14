//
//  IndividualCreationViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2019/12/31.
//  Copyright © 2019 cm0521. All rights reserved.
//

import UIKit
import SwiftUI

class IndividualCreationViewController: UIViewController {

    @IBOutlet weak var individual_tf_name: UITextField!
    @IBOutlet weak var individual_tf_phone: UITextField!
    @IBOutlet weak var individual_tf_account: UITextField!
    @IBOutlet weak var individual_tf_password: UITextField!
    @IBOutlet weak var individual_tf_companyID: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // tap anywhere to dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
    }
    @IBOutlet weak var IndividualCreation_confirm: RoundRecButton!
    @IBAction func IndividualCreation_confirm(_ sender: UIButton) {

//            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
//
//            let saveAction = UIAlertAction(title: "Save", style: .default, handler:
//            {
//                (alert: UIAlertAction!) -> Void in
//                print("Saved")
//            })
//
//            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
//            {
//                (alert: UIAlertAction!) -> Void in
//                print("Deleted")
//            })
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
//            {
//                (alert: UIAlertAction!) -> Void in
//                print("Cancelled")
//            })
//            optionMenu.view.tintColor = UIColor(named : "Color7")
//            optionMenu.view.backgroundColor = UIColor(named : "Color7")
//            optionMenu.addAction(deleteAction)
//            optionMenu.addAction(saveAction)
//            optionMenu.addAction(cancelAction)
//            present(optionMenu, animated: true, completion: nil)
        //
        
        
        let controller1 = UIAlertController(title: "好了嗎？", message: "請確認資訊正確", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "沒問題", style: .default) { (_) in
            if self.individual_tf_account.text == "" || self.individual_tf_password.text == "" || self.individual_tf_name.text == "" || self.individual_tf_phone.text == "" || self.individual_tf_companyID.text == ""{
                Toast.showToast(self.view, "請完整填寫空白處")
            }else{
            
            
            NetWorkController.sharedInstance.post(api: "/register/staff", params: ["account": self.individual_tf_account.text, "password": self.individual_tf_password.text, "name": self.individual_tf_name.text, "number": self.individual_tf_phone.text, "ltdID": self.individual_tf_companyID.text])
            {(jsonData) in
                print(jsonData.description)
                if jsonData.description.contains("200"){
                    
                    self.jumpToSchedule()
                    
                }else{
                    Toast.showToast(self.view, "wrong info")
                }
                }
            }
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == individual_tf_name {
         textField.resignFirstResponder()
         individual_tf_phone.becomeFirstResponder()
      } else if textField == individual_tf_phone {
         textField.resignFirstResponder()
         individual_tf_account.becomeFirstResponder()
      }else if textField == individual_tf_account {
         textField.resignFirstResponder()
         individual_tf_password.becomeFirstResponder()
      }else if textField == individual_tf_password {
         textField.resignFirstResponder()
         individual_tf_companyID.becomeFirstResponder()
      }else if textField == individual_tf_companyID {
         textField.resignFirstResponder()
      }
     return true
    }
    

}

extension IndividualCreationViewController: UITextFieldDelegate {
    /// 開始輸入
    ///
    /// - Parameter textField: _
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
           self.view.frame.origin.y = -50
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
    
    // jump to the page we want by its storyBoard ID
    func jumpToSchedule(){
            if let controller = storyboard?.instantiateViewController(withIdentifier: "navPersonalScheduleViewController") {
                present(controller, animated: true, completion: nil)
            
        }
    }
}
