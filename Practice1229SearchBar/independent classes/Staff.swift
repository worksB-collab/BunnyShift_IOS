//
//  Staff.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation
public class Staff{
    var name: String
    var account: String
    var password: String
    var number: String
    var shiftList : [ShiftDate]?
    var salaryHourly : Int?
    var startWorkingDate : String?
    var assignedWorkingHours : Int? // 本月工作時數
    var currentWorkingHours : Int?
    var staffID : Int
    
       
    init(name : String, staffID : Int, account: String, password: String, number: String){
        self.name = name
        self.staffID = staffID
        self.account = account
        self.password = password
        self.number = number
    }

    func getSalary() -> Int {
        if currentWorkingHours == nil || salaryHourly == nil{
            return 0
        }
        return currentWorkingHours!*salaryHourly! 
    }

}
