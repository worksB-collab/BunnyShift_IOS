//
//  StaffManagementController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/14.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class StaffManagementController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        registerNib()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func registerNib() {
        view.addSubview(tableView)
        self.tableView.register(UINib(nibName: "StaffManagementTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffManagementTableViewCell")
        tableView.frame = CGRect(x: 10, y: 200, width: view.frame.width-20, height: 650);
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        
        //隱藏cell灰色底線
        tableView.tableFooterView = UIView()
    }
    
    func setNav(){
        navigationItem.title = "員工清單"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func jumpToSchedule(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navAssignScheduleController")
        present(controller, animated: true, completion: nil)
        
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
        
        let staff = Global.staffList[indexPath.item]
        cell1.configureCell(name: staff.name, currentWorkingHours : staff.currentWorkingHours ?? 0, assignedWorkingHours : staff.assignedWorkingHours ?? 0, salaryHourly : staff.salaryHourly ?? 0, salaryMonthly : staff.getSalary(), number: staff.number)
        
        cell1.btn_fire.tag = indexPath.row
        cell1.btn_fire.addTarget(self, action: #selector(fireStaff), for: .touchUpInside)
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    @objc func fireStaff(_ sender: UIButton){
        
//        let cells = tableView.cellForRow(at: sender.)
        
        let controller1 = UIAlertController(title: "確定開除\(Global.staffList[sender.tag].name)嗎？", message: "開除後此員工將從清單上移除", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            NetWorkController.sharedInstance.postT(api: "/leave/firestaff", params: ["staffID" : Global.staffList[sender.tag].staffID])
            {(jsonData) in
                if jsonData["Status"].string == "200"{
                    Toast.showToast(self.view, "已開除")
                    Global.staffList.remove(at: sender.tag)
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(okAction)
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected" , indexPath.item)
        let cell1 = tableView.cellForRow(at: indexPath) as! StaffManagementTableViewCell
        
        
        cell1.contentView.backgroundColor = UIColor (named : "Color1")
        cell1.contentView.tintColor = UIColor (named : "Color5")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! StaffManagementTableViewCell
        
        cell1.contentView.backgroundColor = UIColor.clear
    }
    
}
