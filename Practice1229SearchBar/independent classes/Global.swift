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
    
    //company login
    public static var companyInfo : Company?
//    public static var staffList : [String] = []
//    public static var companyShiftDateList : [String : Array<ShiftDate>?]! = [:]
//    public static var shiftDateNames : [String] = []
    
    
    
    public static var staffNameList : [String] = ["ada", "belle"]
    public static var staffList = Array<Staff>()
    public static var companyShiftDateList = ["weekday" : Array<ShiftDate>(), "weekend" : Array<ShiftDate>()]
    public static var shiftDateNames : Array<String> = ["weekday", "weekend"]
    public static var dayType : [String] = []
    
    
    
    //staff login
    public static var staffShiftList : [ShiftDate]? = []
    public static var staffInfo : Staff?
    public static var companyName : String?
    public static var companyPhone : String?
    public static var comapanyID : String?
    public static var companyTaxID : String?
    
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
        Global.self.companyName = companyName
        Global.self.companyPhone = companyPhone
        Global.self.comapanyID = comapanyID
        Global.self.companyTaxID = companyTaxID
        }
    
    static func getCertainTypeShifts(typeName : String) -> Array<String>{
        var arr = Array<String>()
        for i in 0 ..< Global.companyShiftDateList[typeName]!.count{ arr.append(Global.companyShiftDateList[typeName]![i].timeName)
        }
        return arr
    }
}
