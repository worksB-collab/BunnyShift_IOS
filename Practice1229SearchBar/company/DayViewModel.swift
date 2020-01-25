//
//  DefaultViewModel.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 3/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DayViewModel: NSObject {
    
    private var firstDay = Calendar.current.date(byAdding: DateComponents(month: 0, day: 1), to: ScheduleViewController.startMonth)!
    private let firstDate = Date().add(component: .hour, value: 0)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)

    var shifts : [DefaultEvent] = []

    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: shifts)

    var currentSelectedData: OptionsSelectedData!
    
    
    func assignToEachDay(){
        var count = 1
        for i in 0 ..< Global.monthlyShiftArr!.count{
            if Global.monthlyShiftArr?[i] == nil{
                continue
            }
            let date = Global.monthlyShiftArr![i]!.date!.components(separatedBy: "-")
            let day : Int = Int(date[2])!-2
            let timeS = Global.monthlyShiftArr![i]!.startTime!.components(separatedBy: ":")
            let hourS = Int(timeS[0])!
            let minS = Int(timeS[1])!
            let timeE = Global.monthlyShiftArr![i]!.endTime!.components(separatedBy: ":")
            let hourE = Int(timeE[0])!
            let minE = Int(timeE[1])!
            
            let currentDay = firstDay.add(component: .day, value: day).add(component: .hour, value: 0)
            
            shifts.append(DefaultEvent(id: "\(count)",
                title: Global.monthlyShiftArr![i]!.timeName,
                startDate: currentDay.add(component: .hour, value: hourS).add(component: .hour, value: minS),
                endDate: currentDay.add(component: .hour, value: hourE).add(component: .hour, value: minE) ,
                location: Global.monthlyShiftArr![i]!.staffName!))
            count += 1
        }
        
    }
    
    
    func firstD() -> Date{
        return Calendar.current.date(byAdding: DateComponents(month: 0, day: 1), to: self.startOfMonth())!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: ScheduleViewController.date)))!
    }
    
    func countOfDaysInCurrentMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date())
        return (range?.length)!
    }
    
}

