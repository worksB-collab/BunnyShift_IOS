//
//  SNotificationController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/21.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class SNotificationController: UIViewController {

    var shiftNameArr = Array<String>() //shift names
    var shiftStaffArr = Array<Array<String>>()//related with shiftNameArr on staff who has to work
    var date_shift_name : String?
    var selectedDate : String?
    let tableView = UITableView()
    
    var acceptableLeaveArr = Array<LeaveData>()
    var regularRecordArr = Array<LeaveData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        acceptableNotificationUpdate()
        regularNotificationUpdate()
    }
    
    func setNav(){
        navigationItem.title = "通知"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        
    }

    func setTableView(){
        view.addSubview(tableView)
        self.tableView.register(UINib(nibName: "RegularNotificationCell", bundle: nil), forCellReuseIdentifier: "RegularNotificationCell")
        self.tableView.register(UINib(nibName: "AcceptableNotificationCell", bundle: nil), forCellReuseIdentifier: "AcceptableNotificationCell")
        tableView.frame = CGRect(x: 10, y: 200, width: view.frame.width-20, height: 650);
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        
        //隱藏cell灰色底線
        tableView.tableFooterView = UIView()
    }
    
    func acceptableNotificationUpdate(){
        NetWorkController.sharedInstance.get(api: "/leave/checkdeputyinfobystaff")
        {(jsonData) in
            print("xxx? \(jsonData.description)")
            if jsonData["Status"].string == "200"{

                self.acceptableLeaveArr = Array<LeaveData>()
                
                let arr = jsonData["rows"]
                if arr.isEmpty{
                    return
                }
                
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let leaveID = companyJson["leaveID"].int
                    let staffName = companyJson["staffName"].string
                    let deputy = companyJson["deputy"].string
                    let date = companyJson["date"].string
                    let dateShiftName = companyJson["dateShiftName"].string
                    let timeShiftName = companyJson["timeShiftName"].string
                    let startTime = companyJson["startTime"].string
                    let endTime = companyJson["endTime"].string
                    let statusName = companyJson["statusName"].string
                    let submitTime = companyJson["submitTime"].string
                    self.acceptableLeaveArr.append(LeaveData(leaveID : leaveID!, staffName : staffName!, deputy : deputy!, date : date!, dateShiftName : dateShiftName!, timeShiftName : timeShiftName!, startTime : startTime!, endTime : endTime!, statusName : statusName!, submitTime: submitTime!))
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func regularNotificationUpdate(){
        
        NetWorkController.sharedInstance.get(api: "/leave/checkleaveinfobystaff")
        {(jsonData) in
            
            if jsonData["Status"].string == "200"{

                self.regularRecordArr = Array<LeaveData>()
                let arr = jsonData["rows"]
                
                if arr.isEmpty{
                    return
                }
                
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let leaveID = companyJson["leaveID"].int
                    let staffName = companyJson["staffName"].string
                    let deputy = companyJson["deputy"].string
                    let date = companyJson["date"].string
                    let dateShiftName = companyJson["dateShiftName"].string
                    let timeShiftName = companyJson["timeShiftName"].string
                    let startTime = companyJson["startTime"].string
                    let endTime = companyJson["endTime"].string
                    let statusName = companyJson["statusName"].string
                    let submitTime = companyJson["submitTime"].string
                    self.regularRecordArr.append(LeaveData(leaveID : leaveID!, staffName : staffName!, deputy : deputy ?? "查無人員", date : date!, dateShiftName : dateShiftName!, timeShiftName : timeShiftName!, startTime : startTime!, endTime : endTime!, statusName : statusName!, submitTime: submitTime!))
                }
            }
            self.tableView.reloadData()
        }
    }
}



extension SNotificationController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regularRecordArr.count + acceptableLeaveArr.count
    }
    
    @objc func acceptAction(_ sender: UIButton){
        var reviewed : Bool?
        switch sender.currentTitle {
        case "同意":
            reviewed = true
        default:
            reviewed = false
        }
        let leaveID = acceptableLeaveArr[sender.tag].leaveID
        NetWorkController.sharedInstance.postT(api: "/leave/staffreviewdeputy", params: ["leaveID": leaveID, "reviewed": reviewed])
        {(jsonData) in
            print(jsonData.description)
            if jsonData["Status"].string == "200"{
                print(jsonData["message"].string)
                self.acceptableLeaveArr.remove(at: sender.tag)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item < acceptableLeaveArr.count{
            
            let cellIdentifier = "AcceptableNotificationCell"
            let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AcceptableNotificationCell
//            cell1.backgroundColor = UIColor(named: "Color1")
            
            let leaveData = acceptableLeaveArr[indexPath.item]
            
            let notification = "來自\(leaveData.staffName!)的代班請求\n" +
            "\(leaveData.date!) \(leaveData.timeShiftName!)\n" +
            "\(leaveData.startTime!)-\(leaveData.endTime!)\n" +
            "\(leaveData.submitTime!)"
            
            cell1.configureCell(notification: notification)
            cell1.accept?.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
            cell1.reject?.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
                        
            cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
            cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
            cell1.layer.shadowOpacity = 2
            cell1.layer.shadowRadius = 2
            cell1.layer.masksToBounds = false
            
            return cell1
            
        }else{
            let cellIdentifier = "RegularNotificationCell"
            let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RegularNotificationCell
//            cell1.backgroundColor = UIColor(named: "Color1")
            
            let leaveData = regularRecordArr[indexPath.item - acceptableLeaveArr.count]
            let notification = "\(leaveData.statusName!)\n" +
                "由\(leaveData.deputy!)協助\(leaveData.staffName!)代班\n" +
                "時間為\(leaveData.date!) \(leaveData.timeShiftName!)\n" +
                "\(leaveData.startTime!)-\(leaveData.endTime!)\n"
            let time = leaveData.submitTime!
            cell1.configureCell(notification: notification, time: time)
            
            cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
            cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
            cell1.layer.shadowOpacity = 2
            cell1.layer.shadowRadius = 2
            cell1.layer.masksToBounds = false
            
            return cell1
        }
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected" , indexPath.item)
//        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
//
//
//        cell1.contentView.backgroundColor = UIColor (named : "Color1")
//        cell1.tintColor = UIColor (named : "Color5")
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//        print("deSelected" , indexPath.item)
//
//        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
//
//        cell1.contentView.backgroundColor = UIColor.clear
//    }
}

