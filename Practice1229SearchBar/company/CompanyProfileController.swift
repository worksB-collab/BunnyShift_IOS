//
//  CompanyProfileController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/14.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class CompanyProfileController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var companyID: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var companyTaxID: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var staffNum: RoundRecButton!
    @IBAction func logout(_ sender: RoundRecButton) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootNavigationController")
        let controller1 = UIAlertController(title: "登出", message: "確認登出？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "登出", style: .default) { (_) in
            Global.clearData()
            Toast.showToast(self.view, "登出")
            self.present(controller, animated: true, completion: nil)
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadStaffList()
    }
    
    func viewWillAppear(){
        reloadStaffList()
    }
    
    func setInfo(){
        self.name.text = Global.companyInfo?.name
        self.account.text = Global.companyInfo?.account
        self.companyTaxID.text = Global.companyInfo?.taxID
        self.phone.text = Global.companyInfo?.number
        if let cID = Global.companyInfo!.ltdID{
            self.companyID.text = "\(cID)"
        }
        self.address.text = Global.companyInfo?.address
        self.staffNum.titleLabel?.text = "員工人數：\(Global.companyInfo?.staffList?.count ?? 0)"

    }
    
    func reloadStaffList(){
        
        Global.staffList = Array<Staff>()
        NetWorkController.sharedInstance.get(api: "/search/staffinfobycompany")
        {(jsonData) in
            
            if jsonData["Status"].string == "200"{
                
                let arr = jsonData["rows"]
                for _ in 0 ..< arr.count{
                    let staffJson = arr[0]
                    
                    let staffName = staffJson["staffName"].string
                    let staffnumber = staffJson["staffNumber"].string
                    let staffID = staffJson["staffID"].int
                    
                    let staffInfo = Staff(name : staffName!, staffID : staffID!, number: staffnumber!)
                    Global.staffList.append(staffInfo)
                }
                self.setInfo()
            }
        }
    }
}
