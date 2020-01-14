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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = Global.companyInfo?.name
        self.account.text = Global.companyInfo?.account
        self.companyTaxID.text = Global.companyInfo?.taxID
        self.phone.text = Global.companyInfo?.number
        self.companyID.text = Global.companyInfo?.ltdID
        self.address.text = Global.companyInfo?.address
        self.staffNum.titleLabel?.text = "員工人數：\(Global.companyInfo?.staffList?.count)"
        
    }
    

    

}
