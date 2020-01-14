//
//  StaffManagementController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/14.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class StaffManagementController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSettings()
        registerNib()
        
    }
    
    func registerNib() {
    self.tableView?.register(UINib(nibName: "StaffManagementTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffManagementTableViewCell")
    
    let cell1 = tableView?.dequeueReusableCell(withIdentifier: "StaffManagementTableViewCell") as! StaffManagementTableViewCell
    
    tableView.allowsMultipleSelection = false
    
    //隱藏cell灰色底線
    tableView?.tableFooterView = UIView()
    }
    
    func navigationBarSettings(){
        navigationItem.title = "班表排程設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        
    }
    func jumpToSchedule(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "navAssignScheduleController") {
            present(controller, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
            
            
        // 根據各區去計算顯示列數
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
            return Global.staffList.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellIdentifier = "StaffManagementTableViewCell"
            let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StaffManagementTableViewCell
            
            var staff = Global.staffList[indexPath.item]
            cell1.name.titleLabel!.text = staff.name
            
            cell1.currentWorkingHours.titleLabel!.text = "\(staff.currentWorkingHours)"
            
            cell1.assignedWorkingHours.titleLabel!.text = "\(staff.assignedWorkingHours)"
            cell1.salaryHourly.titleLabel!.text = "\(staff.salaryHourly)/hr"
            cell1.salaryMonthly.titleLabel!.text = "\(staff.getSalary())"
            
            cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
            cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
            cell1.layer.shadowOpacity = 2
            cell1.layer.shadowRadius = 2
            cell1.layer.masksToBounds = false
            
            return cell1
            
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("selected" , indexPath.item)
            let cell1 = tableView.cellForRow(at: indexPath) as! StaffManagementTableViewCell
            
            
            cell1.backgroundColor = UIColor (named : "Color1")
            cell1.tintColor = UIColor (named : "Color5")
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            
            print("deSelected" , indexPath.item)
            
            let cell1 = tableView.cellForRow(at: indexPath) as! StaffManagementTableViewCell

            cell1.backgroundColor = UIColor.clear
        }

}
