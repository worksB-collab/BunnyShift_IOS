//
//  ShiftTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/6.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class ShiftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date_name: UITextField!
    @IBOutlet weak var shift_name: UITextField!
//    @IBAction func shift_name(_ sender: UITextField) {
//        shift_name = shift_name.text
//    }
    
    
    @IBOutlet weak var shift_Stime: UITextField!
    @IBOutlet weak var shift_Etime: UITextField!
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    @IBOutlet weak var staffNum: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        
        datePickerSetting()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class var reuseIdentifier: String {
            return "ShiftTableViewCell"
        }
        class var nibName: String {
            return "ShiftTableViewCell"
        }
        
        func configureCell(name: String) {
    //        self.nameLabel.text = name
            
        }
    
    func datePickerSetting(){
        //設置datePicker格式
        datePicker1.datePickerMode = .time
        datePicker2.datePickerMode = .time
        
        //選取時間 -> 以15分鐘為一個間隔
        datePicker1.minuteInterval = 15
        datePicker2.minuteInterval = 15
        
        //設定預設顯示時間 -> 為現在時間
        datePicker1.date = NSDate() as Date
        datePicker2.date = NSDate() as Date
        
        //設置NSDate的格式
        let formatter = DateFormatter()
        
        //設置顯示個格式
        formatter.dateFormat = "HH:mm"
        
        //可以選擇的最早日期時間
        datePicker1.minimumDate = formatter.date(from: "00:00")
        datePicker2.minimumDate = formatter.date(from: "00:00")
        
        //可以選擇的最晚日期時間
        datePicker1.maximumDate = formatter.date(from: "23:59")
        datePicker2.maximumDate = formatter.date(from: "23:59")
        
        //picker預設英文，改為顯示中文
        datePicker1.locale = Locale(identifier: "zh_CN")
        datePicker2.locale = Locale(identifier: "zh_CN")
        
        //設置改變日期時間時會執行動作的方法
        datePicker1.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker2.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        shift_Stime.inputView = datePicker1
        shift_Etime.inputView = datePicker2

        
        
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 textField 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        // 更新 textField 的內容
        shift_Stime.text = formatter.string(from: datePicker1.date)
        
        shift_Etime.text = formatter.string(from: datePicker2.date)
    }
    
}
