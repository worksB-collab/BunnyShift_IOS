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
    
    public static var token : String?
    
    //company login
    public static var companyInfo : Company?
//    public static var staffList : [String] = []
    public static var companyShiftDateList : [String : Array<ShiftDate>?]! = [:]
//    public static var shiftDateNames : [String] = []
    
    
    
    public static var staffNameList : [String] = ["Anders", "Kristian", "Sofia", "John", "Jenny", "Lina", "Annie", "Katie", "Johanna"]
    public static var staffList = Array<Staff>()
//    public static var companyShiftDateList = ["weekday" : Array<ShiftDate>(), "weekend" : Array<ShiftDate>()]
    public static var shiftDateNames : Array<String> = ["weekday", "weekend"]
    public static var dayType : [String] = [] // 每個星期的日子是什麼日別
       
    
    
    //staff login
    public static var staffShiftList : [ShiftDate]? = []
    public static var staffInfo : Staff?
    
    public static var date : String? = ""
    
    init(){
        
    }
//    init(_ companyInfo : Company, _ staffList : [String], _ companyShiftDateList : [String : Array<ShiftDate>?.self]){
//        Global.self.companyInfo = companyInfo
//        Global.self.staffList = staffList
//        Global.self.companyShiftDateList = companyShiftDateList
//    }
    
    init(_ staffShiftDateList : [ShiftDate], _ staffInfo : Staff, _ companyName : String, _ companyPhone : String, _ comapanyID : String, _ companyTaxID : String){
        Global.self.staffShiftList = staffShiftDateList
        Global.self.staffInfo = staffInfo
        Global.self.companyInfo?.name = companyName
        Global.self.companyInfo?.number = companyPhone
        Global.self.companyInfo?.ltdID = comapanyID
        Global.self.companyInfo?.taxID = companyTaxID
        }
    
    static func getCertainTypeShifts(typeName : String) -> Array<String>{
        var arr = Array<String>()
        for i in 0 ..< Global.companyShiftDateList[typeName]!!.count{ arr.append(Global.companyShiftDateList[typeName]!![i].timeName)
        }
        return arr
    }
}
