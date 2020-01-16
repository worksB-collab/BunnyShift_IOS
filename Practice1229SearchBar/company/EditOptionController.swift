//
//  EditOptionController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/14.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class EditOptionController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    var optionNames = ["新增日別","班別設定","每週日別設定","個別日別設定","班表排程設定", ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        registerNib()
        // Do any additional setup after loading the view.
    }
    
    func setNav(){
        
        navigationController?.title = "各種設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func jumpToDateNamingController(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navDateNamingController")
        present(controller, animated: true, completion: nil)
        
    }
    func jumpToShiftArrangementViewController(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navShiftArrangementViewController")
        present(controller, animated: true, completion: nil)
        
    }
    func jumpToDateShiftAssignController(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navDateShiftAssignController")
        present(controller, animated: true, completion: nil)
        
    }
    func jumpToCertainDayTypeController(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navCertainDayTypeController")
        present(controller, animated: true, completion: nil)
        
    }
    func jumpToAssignScheduleController(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navAssignScheduleController")
        present(controller, animated: true, completion: nil)
        
    }
    
    
    func registerNib() {
        //shift tableView
        self.tableView.register(UINib(nibName: "DateNamingTableViewCell", bundle: nil), forCellReuseIdentifier: "DateNamingTableViewCell")
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "DateNamingTableViewCell") as! DateNamingTableViewCell
        
        //隱藏cell灰色底線
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return optionNames.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DateNamingTableViewCell"
        // 把 tableView 中叫 datacell 的畫面部分跟 TestTableViewCell 類別做連結
        // 用 as！轉型(轉成需要顯示的cell : TestTableViewCell)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DateNamingTableViewCell
        
        
        cell1.dateName.text = optionNames[indexPath.row]
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        switch indexPath.item {
        case 0:
            jumpToDateNamingController()
        case 1:
            jumpToShiftArrangementViewController()
        case 2:
            jumpToDateShiftAssignController()
        case 3:
            jumpToCertainDayTypeController()
        case 4:
            jumpToAssignScheduleController()
        default:
            print("error selection")
        }
    }
    
}
