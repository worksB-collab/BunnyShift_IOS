//
//  ShiftArrangementViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/6.
//  Copyright © 2020 cm0521. All rights reserved.
//
//班別設定

import UIKit

class ShiftArrangementViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var addDateShift:UITextField?
    var addTimeShift :UITextField?
    var addStartTime:UITextField?
    var addEndTime :UITextField?
    var addStaffNum :UITextField?
    
    let pickerView = UIPickerView()
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var shiftDate : ShiftDate?
    var currentShiftArr = Array<ShiftDate>()
    
    var shiftCells = 1
    var shiftAdd = false
    var addItem = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var shift_tableView: UITableView!
    @IBAction func save(_ sender: UIBarButtonItem) {

        if currentShiftArr.count == 0{
            let controller1 = UIAlertController(title: "忘記填了嗎？", message: "請至少書輸入一項班別", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel) { (_) in
            }
            controller1.addAction(cancelAction)
            present(controller1, animated: true, completion: nil)
        }
        jumpToNext()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        
        let controller1 = UIAlertController(title: "新增班別", message: "請輸入以下資訊", preferredStyle: .alert)
        
        controller1.addTextField { (textField) in
        textField.placeholder = "日別"
            textField.tag = 0
            textField.inputView = self.pickerView
            textField.text = Global.shiftDateNames[0]
            self.addDateShift = textField
        }
        
        controller1.addTextField { (textField) in
        textField.placeholder = "班別"
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 1
            self.addTimeShift = textField
        }
        
        controller1.addTextField{ (textField) in
            textField.placeholder = "開始時間"
            textField.text = "00:00" // for testing
            textField.tag = 2
            self.addStartTime = textField
            //        textField.keyboardType = UIKeyboardType.phonePad
            
            self.datePicker1.datePickerMode = .time
            self.datePicker1.minuteInterval = 15
            self.datePicker1.date = NSDate() as Date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.datePicker1.minimumDate = formatter.date(from: "00:00")
            self.datePicker1.maximumDate = formatter.date(from: "23:59")
            self.datePicker1.locale = Locale(identifier: "zh_CN")
            self.datePicker1.addTarget(self, action: #selector(self.dateSPickerChanged), for: .valueChanged)
            textField.inputView = self.datePicker1
            
        }
        
        controller1.addTextField{ (textField) in
            textField.placeholder = "結束時間"
            textField.text = "23:59" // for testing
            textField.tag = 3
            self.addEndTime = textField
            //        textField.keyboardType = UIKeyboardType.phonePad
            
            self.datePicker2.datePickerMode = .time
            self.datePicker2.minuteInterval = 15
            self.datePicker2.date = NSDate() as Date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.datePicker2.minimumDate = formatter.date(from: "00:00")
            self.datePicker2.maximumDate = formatter.date(from: "23:59")
            self.datePicker2.locale = Locale(identifier: "zh_CN")
            self.datePicker2.addTarget(self, action: #selector(self.dateEPickerChanged), for: .valueChanged)
            textField.inputView = self.datePicker2

        }
        
        controller1.addTextField { (textField) in
        textField.placeholder = "人數"
            textField.keyboardType = UIKeyboardType.numberPad
            textField.tag = 4
            self.addStaffNum = textField
        }
                
        let okAction = UIAlertAction(title: "儲存", style: .default) { (_) in
                self.pickerView.selectRow(0, inComponent:0, animated:true)
                self.setDataProperly()
                self.shift_tableView.reloadData()
        }
        
        controller1.addAction(okAction)
        
                
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
        }
        controller1.addAction(cancelAction)
        present(controller1, animated: true, completion: nil)
        
    }
    
    func setDataProperly(){
        
        shiftDate = ShiftDate(self.addDateShift!.text!, self.addTimeShift!.text!, self.addStartTime!.text!, self.addEndTime!.text!, self.addStaffNum!.text!)
        
        self.currentShiftArr.append(shiftDate!)
        
        for i in Global.shiftDateNames{
            
            if i == self.addDateShift!.text!{
                
                var oldNameShift = Array<ShiftDate>( Global.companyShiftDateList[self.addDateShift!.text!]!)
                oldNameShift.append(shiftDate!)
                
                Global.companyShiftDateList.updateValue(oldNameShift, forKey: self.addDateShift!.text!)
               print("old title")
               return
            }
        }
        
        var newShift = Array<ShiftDate>()
        newShift.append(shiftDate!)
        
         Global.shiftDateNames.append(self.addDateShift!.text!)
         Global.companyShiftDateList.updateValue(newShift, forKey: self.addDateShift!.text!)
         print("new title")
    }
    
    @objc func dateSPickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 textField 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.addStartTime?.text = formatter.string(from: self.datePicker1.date)
    }
    
    @objc func dateEPickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 textField 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.addEndTime?.text = formatter.string(from: self.datePicker2.date)
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        registerNib()
        //監聽tap鍵盤的事件 -> 點擊螢幕關閉pickerView
        // An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
        hideKeyboardWhenTappedAround()
        setPickerView()
    }

    func setNav(){
        navigationController?.title = "班別設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
        
    func jumpToNext(){
       let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navDateShiftAssignController") 
                present(controller, animated: true, completion: nil)
       
    }
    
    func registerNib() {
        //shift tableView
        self.shift_tableView.register(UINib(nibName: "LabelShiftTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelShiftTableViewCell")
        
        let cell1 = shift_tableView.dequeueReusableCell(withIdentifier: "LabelShiftTableViewCell") as! LabelShiftTableViewCell
        
        //隱藏cell灰色底線
        shift_tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShiftArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LabelShiftTableViewCell"
        // 把 tableView 中叫 datacell 的畫面部分跟 TestTableViewCell 類別做連結
        // 用 as！轉型(轉成需要顯示的cell : TestTableViewCell)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LabelShiftTableViewCell
        
        cell1.date_label.text = currentShiftArr[indexPath.row].dateName
        cell1.time_label.text = currentShiftArr[indexPath.row].timeName
        cell1.start_label.text = currentShiftArr[indexPath.row].startTime
        cell1.end_label.text = currentShiftArr[indexPath.row].endTime
        cell1.staffNum_label.text = currentShiftArr[indexPath.row].staffNum
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    // picker view
    func setPickerView(){
        //設定代理人和資料來源為viewController
        pickerView.dataSource = self//告訴pickerView要從哪個view controller中取得要顯示的資料
        pickerView.delegate = self //告訴pickerView當使用者選了選項後 要讓哪一個view controller知道使用者的選擇
                        
        //讓textfiled的輸入方式改為pickerView
        addDateShift?.inputView = pickerView
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
            return Global.shiftDateNames.count
        }
        return 0
    }

    //設定資料的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return Global.shiftDateNames[row]
        }
        return nil
    }

    //定義選取後的行為
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int){
        if component == 0{
            addDateShift?.text = Global.shiftDateNames[row]
        }
    }
    
    //監聽tap鍵盤的事件 -> 點擊螢幕關閉pickerView
    // An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    
}

