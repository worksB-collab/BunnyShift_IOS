//
//  LoginViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2019/12/30.
//  Copyright © 2019 cm0521. All rights reserved.
//

import UIKit
import GoogleSignIn


class LoginViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var login_tf_account: UITextField!
    @IBOutlet weak var login_tf_password: UITextField!
    
    @IBOutlet weak var loginIdentify: UITextField!
    let pickerView = UIPickerView()
    let identifyList = ["個人登入","公司登入"]
    
    @IBAction func login_btn_GoogleLogin(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBOutlet weak var login_btn_login: RoundRecButton!
    
    @IBAction func login_btn_login(_ sender: UIButton) {
        if login_tf_password.text == "" || login_tf_account.text == "" || loginIdentify.text == "" {
            let controller = UIAlertController(title: "資料未完成", message: "請輸入正確的身份，帳號及密碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default) { (_) in
                print("請輸入正確的身份，帳號及密碼")
            }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return
        }
        if loginIdentify.text == "公司登入"{
            NetWorkController.sharedInstance.post(api: "/login/company", params: ["account": login_tf_account.text, "password": login_tf_password.text])
            {(jsonData) in
                print(jsonData.description)
                if jsonData.description.contains("200"){
                    
                    
                    let token = jsonData["token"].string
                    Global.token = token
                    
                    NetWorkController.sharedInstance.get(api: "/search/companyinfo")
                    {(jsonData) in
                        //待確認有哪些資訊可以拿
                        if jsonData["Status"].string == "200"{
                            var arr = jsonData["rows"].dictionary
                            Global.companyInfo?.ltdID = arr!["ltd_id"]!.string!
                            Global.companyInfo?.name = arr!["ltd_name"]!.string!
                            Global.companyInfo?.account = arr!["ltd_account"]!.string!
                            Global.companyInfo?.password = arr!["ltd_password"]!.string!
                            Global.companyInfo?.number = arr!["ltd_number"]!.string!
                            Global.companyInfo?.address = arr!["address"]!.string!
                            Global.companyInfo?.taxID = arr!["tax_id"]!.string!
                        }
                        
                    }
                    
                    let preferencesSave = UserDefaults.standard
                    preferencesSave.set(self.login_tf_account.text!, forKey: "account")
                    preferencesSave.set(self.login_tf_password.text! , forKey: "password")
                    //儲存
                    let didSave = preferencesSave.synchronize()
                    self.jumpToCompany()
                    
                }else{
                    Toast.showToast(self.view, "錯誤的帳號或密碼")
                }
                
            }
        }else{
            NetWorkController.sharedInstance.post(api: "/login/staff", params: ["account": login_tf_account.text, "password": login_tf_password.text])
            {(jsonData) in
                print(jsonData.description)
                if jsonData.description.contains("200"){
                    
                    let token = jsonData["token"].string
                    Global.token = token
                    
                    
                    NetWorkController.sharedInstance.get(api: "/search/companyinfo")
                    {(jsonData) in
                        
                        if jsonData["Status"].string == "200"{
                            var arr = jsonData["rows"].dictionary
                            Global.companyInfo?.ltdID = arr!["ltd_id"]!.string!
                            Global.staffInfo?.name = arr!["staff_name"]!.string!
                            Global.staffInfo?.account = arr!["staff_account"]!.string!
                            Global.staffInfo?.password = arr!["staff_password"]!.string!
                            Global.staffInfo?.number = arr!["staff_number"]!.string!
                            Global.staffInfo?.staffID = arr!["staff_id"]!.string!
                        }
                    }
                        
                    
                    let preferencesSave = UserDefaults.standard
                    preferencesSave.set(self.login_tf_account.text!, forKey: "account")
                    preferencesSave.set(self.login_tf_password.text! , forKey: "password")
                    //儲存
                    let didSave = preferencesSave.synchronize()
                    self.jumpToStaff()
                    
                    
                }else{
                    Toast.showToast(self.view, "錯誤的帳號或密碼")
                }
                
            }
        }
        
    }
    @IBAction func forgotPassword(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Email", message: "", preferredStyle: .alert)
        
        // Change font and color of title
        alertController.setTitlet(font: UIFont.systemFont(ofSize: 20), color: UIColor(named :"Color3"))
        
        // Change font and color of message
        alertController.setMessage(font: UIFont.boldSystemFont(ofSize: 12), color: UIColor(named :"Color3"))
        
        // Change background color of UIAlertController
        alertController.setBackgroundColor(color: UIColor.white)
        
        
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "帳號"
            textField.keyboardType = UIKeyboardType.emailAddress
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
                let account = alertController.textFields?[0].text
                print(account!)
                // action after click ok type here
                //連ＡＰＩ確認是否有帳號
                Toast.showToast(self.view, "Done!")
            }
            alertController.addAction(okAction)
        }
        let action = UIAlertAction(title: "取消", style: .cancel){
            (_) in
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        identifyPickerSettings()
        //google sign in
        GIDSignIn.sharedInstance().presentingViewController = self
        
        
        
        
        //        // networkcontroller example start
        //        NetWorkController.sharedInstance.connectApiByPost(api: "/members/login", params: ["email": "123@", "password": "123"])
        //        {(jsonData) in
        //            print(jsonData.description)
        //        }
        //        // networkcontroller example end
        
        // example end
        //        // test get
        //        NetWorkController.sharedInstance.get(api : ""){(jsonData) in
        //            print(jsonData.description)
        //        }
        //        // test get end
        
    }
    
    
    //    //google sign in
    //    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
    //      withError error: NSError!) {
    //        if (error == nil) {
    //          // Perform any operations on signed in user here.
    //          // ...
    //        } else {
    //          print("\(error.localizedDescription)")
    //        }
    //    }
    
    // set next button in keyboard focus on the next textfield
    
    func jumpToCompany(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "companyMain")
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func jumpToStaff(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "staffMain")
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func identifyPickerSettings(){
        //設定代理人和資料來源為viewController
        loginIdentify?.text = "個人登入"
        pickerView.dataSource = self//告訴pickerView要從哪個view controller中取得要顯示的資料
        pickerView.delegate = self //告訴pickerView當使用者選了選項後 要讓哪一個view controller知道使用者的選擇
        
        //讓textfiled的輸入方式改為pickerView
        loginIdentify?.inputView = pickerView
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
        if component == 0{
            return identifyList.count
        }
        
        return 0
    }
    
    //設定資料的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return identifyList[row]
        }
        return nil
    }
    
    //定義選取後的行為
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int){
        
        if component == 0{
            print("使用:\(identifyList[row])")
            loginIdentify.text = identifyList[row]
        }
    }
    
    //監聽tap鍵盤的事件 -> 點擊螢幕關閉pickerView
    // An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    
    //按下return接續到下一個textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == login_tf_account {
            textField.resignFirstResponder()
            login_tf_password.becomeFirstResponder()
        } else if textField == login_tf_password {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    //hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}

// extension that let user to tap anywhere to dismiss keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// 鍵盤出現時view往上移動
extension LoginViewController: UITextFieldDelegate {
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
}
