//
//  Global.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation

public class Global{
    
    static let sharedInstance = Global()
    
    public static var identity : String?
    public static var token : String?
    //company login
    public static var companyInfo : Company?
    public static var companyShiftDateList : [String : Array<ShiftDate>?]! = [:]
    public static var staffList = Array<Staff>()
    public static var shiftDateNames = Array<String>() // 日別名稱
    public static var shiftTimeNames = Array<String>() // 班別名稱
    public static var dayType = Array(repeating: "", count: 7) // 每個星期的日子是什麼日別
    public static var monthlyShiftArr : Array<ShiftDate?>? // 整個月所有的班別
    public static var eventDotsArr : [String] = []
    
    public static var dailyShiftArr = Array<ShiftDate>()
    public static var temDateShiftIDs : Dictionary<String , Int> = [:]
    
    public static var temTimeShiftNames = Array<String>()
    
//    public static var staffNameList : [String] = ["Anders", "Kristian", "Sofia", "John", "Jenny", "Lina", "Annie", "Katie", "Johanna"]
       
    
    
    //staff login
    public static var staffShiftList : [ShiftDate]? = []
    public static var staffInfo : Staff?
    
    public static var date : String? = ""
    
    init(){
        
    }
    
    init(_ staffShiftDateList : [ShiftDate], _ staffInfo : Staff, _ companyName : String, _ companyPhone : String, _ comapanyID : Int, _ companyTaxID : String){
        Global.self.staffShiftList = staffShiftDateList
        Global.self.staffInfo = staffInfo
        Global.self.companyInfo?.name = companyName
        Global.self.companyInfo?.number = companyPhone
        Global.self.companyInfo?.ltdID = comapanyID
        Global.self.companyInfo?.taxID = companyTaxID
        }
    
    //獲得所有班別的arr
    static func getCertainTypeShifts(typeName : String) -> Array<String>{
        var arr = Array<String>()
        for i in 0 ..< Global.companyShiftDateList[typeName]!!.count{
            arr.append(Global.companyShiftDateList[typeName]!![i].timeName)
        }
        return arr
    }
    
    //獲得對應所有班別的日別arr
    static func getCertainDateShifts(typeName : String) -> Array<String>{
        var arr = Array<String>()
        for i in 0 ..< Global.companyShiftDateList[typeName]!!.count{
            arr.append(Global.companyShiftDateList[typeName]!![i].timeName)
        }
        return arr
    }
    
    static func clearData(){ // call it when logging out
        identity = nil
        token = nil
        
        companyInfo = nil
        companyShiftDateList = [:]
        staffList = Array<Staff>()
        shiftDateNames = Array<String>() // 日別名稱
        shiftTimeNames = Array<String>() // 班別名稱
        dayType = Array(repeating: "", count: 7) // 每個星期的日子是什麼日別
        monthlyShiftArr = nil // 整個月所有的班別
        eventDotsArr = []
        
        dailyShiftArr = Array<ShiftDate>()
        temDateShiftIDs = [:]
        
        staffShiftList  = []
        staffInfo = nil
        date = nil
    }
}
