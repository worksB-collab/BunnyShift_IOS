//
//  PersonalProfileController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class PersonalProfileController: UIViewController {
    
    @IBAction func logout(_ sender: RoundRecButton) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootNavigationController")
        let controller1 = UIAlertController(title: "登出", message: "確認登出？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "登出", style: .default) { (_) in
            
            Toast.showToast(self.view, "登出")
            self.present(controller, animated: true, completion: nil)
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
    }
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var account: UILabel?
    @IBOutlet weak var phone: UILabel?
    @IBOutlet weak var companyName: UILabel?
    @IBOutlet weak var companyID: UILabel?
    @IBOutlet weak var companyPhone: UILabel?
    @IBOutlet weak var companyTaxID: UILabel?
    @IBOutlet weak var companyAddress: UILabel?
    @IBOutlet weak var salaryHourly: UILabel?
    @IBOutlet weak var currentWorkingHours: UILabel?
    @IBOutlet weak var salaryMonthly: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
        Global.staffInfo = Staff("Chad", "ImChad", "yesIm", "0985231245")
        Global.staffInfo?.salaryHourly = 150
        Global.staffInfo?.currentWorkingHours = 50
        Global.staffInfo?.assignedWorkingHours = 150
        Global.companyInfo = Company("CMoney", "02-65456589", "taipei taipei" , "87944456", "companyID")
        //test
        setInfo()
        // Do any additional setup after loading the view.
        
        
    }
    
    func setInfo(){
        self.name?.text = Global.staffInfo?.name
        self.account?.text = Global.staffInfo?.account
        self.phone?.text = Global.staffInfo?.number
        self.companyName?.text = Global.companyInfo?.name
        self.companyID?.text = Global.companyInfo?.ltdID
        self.companyPhone?.text = Global.companyInfo?.number
        self.companyTaxID?.text = Global.companyInfo?.taxID
        self.companyAddress?.text = Global.companyInfo?.address
        self.salaryHourly?.text = "\(Global.staffInfo!.salaryHourly!)"
        self.currentWorkingHours?.text = "\(Global.staffInfo!.currentWorkingHours!)"
        self.salaryMonthly?.text = "\(Global.staffInfo!.getSalary())"
        
    }
    
}
