//
//  Updates.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/26.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation
import FSCalendar

public class Updates{
    
    fileprivate static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static var dailyManPower : Array<Int>?
    static var dailyStaffDemend : Array<Int>?
    // 從後端把所有當月班表撈出來
    @objc static func getMonthData(calendar : FSCalendar){
        //停止更新
        
        if Global.companyInfo == nil{
            return
        }
        ScheduleViewController.selectedDate = dateFormatter.string(from: calendar.currentPage)

        let date = ScheduleViewController.selectedDate?.components(separatedBy: "-")
        let year = date![0]
        let month = date![1]
        _ = date![2]
        var dateArr = Array<ShiftDate>()
        var first = true // 確認是否第一次拿資料，用以判斷dateArr是否為空值
        // get dateID
        //var abs = Global.companyInfo?.ltdID!
        
        var a = ""
        if let abs = Global.companyInfo!.ltdID{
            a += "/search/schedule/" + year + "/" + month + "/\(abs)"
        }
        
        NetWorkController.sharedInstance.get(api: a){(jsonData) in
            dateArr = Array<ShiftDate>()
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    
                    let date = companyJson["date"].string
                    let dateShiftName = companyJson["dateShiftName"].string
                    let timeShiftName = companyJson["timeShiftName"].string
                    let startTime = companyJson["startTime"].string
                    let endTime = companyJson["endTime"].string
                    let staffNum = companyJson["number"].int
                    let staffName = companyJson["staffName"].string
                    var matchDateArr = true
                    
                    if first {
                        dateArr.append(ShiftDate(date!, dateShiftName!, timeShiftName!, startTime!, endTime!, staffNum!, staffName!))
                        first = false
                    }else{
                        for j in dateArr{
                            if date != j.date || dateShiftName != j.dateName || timeShiftName != j.timeName{
                                matchDateArr = false
                            }
                        }
                        if !matchDateArr{
                            dateArr.append(ShiftDate(date!, dateShiftName!, timeShiftName!, startTime!, endTime!, staffNum!, staffName!))
                            matchDateArr = true
                        }
                    }
                }
                self.setCompanyShiftDateList(dateArr : dateArr )
                Global.monthlyShiftArr = dateArr
                self.seeNotEnoughDates(calendar : calendar)
            }
        }
    }
    
    //把Global.companyShiftDateList資料也建好
    static func setCompanyShiftDateList(dateArr : Array<ShiftDate>){
        var matched = false
        for i in dateArr{
            if Global.companyShiftDateList[i.dateName] != nil{
                var temArr = Array<ShiftDate>()
                for j in Global.companyShiftDateList![i.dateName]!!{
                    temArr.append(j)
                }
                Global.companyShiftDateList.updateValue(temArr, forKey: i.dateName)
                matched = true
            }
            if !matched{
                var temArr = Array<ShiftDate>()
                temArr.append(i)
                Global.companyShiftDateList.updateValue(temArr, forKey: i.dateName)
            }
        }
    }
    
    //原本要做人數不夠標記紅點的方法，但時間關係目前改為製作已排班日期標記紅點
    static func seeNotEnoughDates(calendar : FSCalendar){
        dailyManPower = Array(repeating : 0, count : countOfDaysInCurrentMonth(fscalendar : calendar))
        dailyStaffDemend = Array(repeating : 0, count : countOfDaysInCurrentMonth(fscalendar : calendar))
        let daysinMonth = countOfDaysInCurrentMonth(fscalendar : calendar)
        for i in 0 ..< daysinMonth {
            for j in Global.monthlyShiftArr!{
                let date = j?.date!.components(separatedBy: "-")
                let day = Int(date![2])
                if day == i{
                    dailyManPower![i] += 1
                }
                
            }
        }
        //有安排班表的日子 （紅點會標記這些日子）
        for i in 0 ..< dailyManPower!.count{
            switch Global.identity {
            case "公司":
                if dailyManPower![i] > 0{
                    let theDay = dateFormatter.string(from: calendar.currentPage.startOfDay.add(component: .day, value: i-1))
                    Global.eventDotsArr.append(theDay)
                }
            default:
                for j in Global.monthlyShiftArr!{
                    
                    let date1 = j!.date!.components(separatedBy: "-")
                    let day = date1[2]
                    let dayofdailyManPower = i < 10 ? "0" + "\(i)" : "\(i)"
                    
                    if dailyManPower![i] > 0 , j!.staffName == Global.staffInfo?.name, day == dayofdailyManPower{
                        let theDay = dateFormatter.string(from: calendar.currentPage.startOfDay.add(component: .day, value: i-1))
                        Global.eventDotsArr.append(theDay)
                    }
                }
                for j in Global.eventDotsArr{
                }
            }
        }
        calendar.reloadData()
    }
    
    static func countOfDaysInCurrentMonth(fscalendar : FSCalendar) ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for:  fscalendar.currentPage)
        return (range?.length)!
    }
}
