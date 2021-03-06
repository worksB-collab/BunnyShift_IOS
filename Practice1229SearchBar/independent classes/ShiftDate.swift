//
//  ShiftDate.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation

public class ShiftDate{
    
    var date : String?
    var dateName : String
    var timeName : String
    var startTime : String?
    var endTime : String?
    var staffNum : Int?
    var staffName : String?
    
    init(_ dateName : String, _ timeName : String){
        self.dateName = dateName
        self.timeName = timeName
    }
    
    init(_ date : String, _ dateName : String, _ timeName : String, _ startTime : String, _ endTime : String, _ staffNum : Int, _ staffName : String){
        self.date = date
        self.dateName = dateName
        self.timeName = timeName
        self.startTime = startTime
        self.endTime = endTime
        self.staffNum = staffNum
        self.staffName = staffName
    }
    
    init(_ dateName : String, _ timeName : String, _ startTime : String, _ endTime : String, _ staffNum : Int){
        self.dateName = dateName
        self.timeName = timeName
        self.startTime = startTime
        self.endTime = endTime
        self.staffNum = staffNum
    }
    
    
}
