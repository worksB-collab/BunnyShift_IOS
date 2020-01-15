//
//  DateNamingController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/10.
//  Copyright © 2020 cm0521. All rights reserved.
//
//新增日別

import UIKit

class DateNamingController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    var addDateName:UITextField?
    
    var tableViewCellArr = Global.shiftDateNames
    
    
    var shiftCells = 1
    var shiftAdd = false
    var addItem = 1
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if tableViewCellArr.count == 0 {
            let controller1 = UIAlertController(title: "忘記填了嗎？", message: "請至少書輸入一項日別", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel) { (_) in
            }
            controller1.addAction(cancelAction)
            present(controller1, animated: true, completion: nil)
            
        }else{
            
            Global.shiftDateNames = tableViewCellArr
            jumpToNext()
        }
        
    }
    
    @IBOutlet weak var shift_tableView: UITableView!

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        
        let controller1 = UIAlertController(title: "新增日別", message: "請輸入以下資訊", preferredStyle: .alert)
        
        controller1.addTextField { (textField) in
        textField.placeholder = "日別"
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 0
            self.addDateName = textField
        }
        
        
        let okAction = UIAlertAction(title: "儲存", style: .default) { (_) in
            self.tableViewCellArr.append( self.addDateName!.text!)
            Global.companyShiftDateList.updateValue( Array<ShiftDate>() , forKey: self.addDateName!.text!)
            
            Global.shiftDateNames.append( self.addDateName!.text!)
            
            self.shift_tableView.reloadData()
            
        }
        controller1.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navSetting()
        registerNib()
        //監聽tap鍵盤的事件 -> 點擊螢幕關閉pickerView
        // An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
        hideKeyboardWhenTappedAround()
        
    }

    
    func navSetting(){
        
        navigationController?.title = "新增日別"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func jumpToNext(){
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navShiftArrangementViewController")
        present(controller, animated: true, completion: nil)
        
    }
    
    func registerNib() {
        //shift tableView
        self.shift_tableView.register(UINib(nibName: "DateNamingTableViewCell", bundle: nil), forCellReuseIdentifier: "DateNamingTableViewCell")
        
        let cell1 = shift_tableView.dequeueReusableCell(withIdentifier: "DateNamingTableViewCell") as! DateNamingTableViewCell
        
        //隱藏cell灰色底線
        shift_tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    // 設置tableView每個Header的高度
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
//    // 設置tableView每個Header的內容
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
//        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
//        viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
//
//        if section == 0{
//            viewLabel.text = "班別"
////        }else if section == 1{
////            viewLabel.text = "日期別"
//        }
//        view.addSubview(viewLabel)
//        tableView.addSubview(view)
//        return view
//    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableViewCellArr.count
        }
        
        return addItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DateNamingTableViewCell"
        // 把 tableView 中叫 datacell 的畫面部分跟 TestTableViewCell 類別做連結
        // 用 as！轉型(轉成需要顯示的cell : TestTableViewCell)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DateNamingTableViewCell
        
        
        cell1.dateName.text = tableViewCellArr[indexPath.row]
        
            cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
            cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
            cell1.layer.shadowOpacity = 2
            cell1.layer.shadowRadius = 2
            cell1.layer.masksToBounds = false
        
            return cell1
        
    }
    
    func tableView(_ tableView: UITableView,
                      commit editingStyle: UITableViewCell.EditingStyle,
                               forRowAt indexPath: IndexPath)
       {
        
        tableViewCellArr.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .automatic)
           tableView.reloadData() // 更新tableView
       }
    
}
