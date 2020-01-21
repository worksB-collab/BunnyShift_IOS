//
//  DayViewTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/15.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class DayViewTableViewCell: UITableViewCell {

    @IBOutlet weak var dateShift: UILabel!
    @IBOutlet weak var staffNum: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var staffs: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class var reuseIdentifier: String {
        return "DayViewTableViewCell"
    }
    class var nibName: String {
        return "DayViewTableViewCell"
    }
    
    //有bug拉幹
    func configureCell(dateShift: String, staffNum : String, startTime : String, endTime : String, staffs : Array<String>) {
        self.dateShift.text = dateShift
        self.staffNum.text = "需求 \(staffNum) 人"
        self.startTime.text = startTime
        self.endTime.text = endTime

        var s : String = ""
        for i in staffs{
            if s != ""{
                s += ", " + i
            }
            s += i
        }

        self.staffs!.text = s
    }
}
