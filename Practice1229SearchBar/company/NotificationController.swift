//
//  NotificationController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/21.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {

    var shiftNameArr = Array<String>() //shift names
    var shiftStaffArr = Array<Array<String>>()//related with shiftNameArr on staff who has to work
    var date_shift_name : String?
    var selectedDate : String?
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func setNav(){
        navigationItem.title = "班表排程設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        
    }

    func setTableView(){
        view.addSubview(tableView)
        self.tableView.register(DayViewTableViewCell.self, forCellReuseIdentifier: "DayViewTableViewCell")
        tableView.frame = CGRect(x: 10, y: 700, width: view.frame.width-20, height: view.frame.height-750);
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        
        //隱藏cell灰色底線
        tableView.tableFooterView = UIView()
        

    }
}

extension NotificationController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shiftNameArr.count //需要依據當天為平日或假日給予不同的array
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DayViewTableViewCell"
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DayViewTableViewCell
        
        cell1.backgroundColor = UIColor(named: "Color1")
        //  待填寫每個被按到當天的資料
        if selectedDate == "" || selectedDate == nil{
            return UITableViewCell()
            
        }
        
        var currentShift = Global.companyShiftDateList[date_shift_name!]!![indexPath.item]
        
        cell1.configureCell(dateShift: shiftNameArr[indexPath.item], staffNum: currentShift.staffNum!, startTime: currentShift.startTime!, endTime: currentShift.endTime!, staffs: shiftStaffArr[indexPath.item])
        
        //小倩的範例
        //        let departureLat = jsonData[i]["departureLat"].double
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected" , indexPath.item)
        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
        
        
        cell1.backgroundColor = UIColor (named : "Color1")
        cell1.tintColor = UIColor (named : "Color5")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
        
        cell1.backgroundColor = UIColor.clear
    }
    
}

