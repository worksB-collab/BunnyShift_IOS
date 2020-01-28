//
//  LeaveData.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/27.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation

public class LeaveData{
    var leaveID : Int?
    var staffName : String? // 請假員工姓名
    var deputy : String? // 代班員工姓名
    var date : String?
    var dateShiftName : String?
    var timeShiftName : String?
    var startTime : String?
    var endTime : String?
    var statusName : String?
    var submitTime : String?
    
    
    init(leaveID : Int, staffName : String, deputy : String, date : String, dateShiftName : String, timeShiftName : String, startTime : String, endTime : String, statusName : String, submitTime: String) {
        self.leaveID = leaveID
        self.staffName = staffName
        self.deputy = deputy
        self.date = date
        self.dateShiftName = dateShiftName
        self.timeShiftName = timeShiftName
        self.startTime = startTime
        self.endTime = endTime
        self.statusName = statusName
        self.submitTime = submitTime
        
    }
    
    
}
