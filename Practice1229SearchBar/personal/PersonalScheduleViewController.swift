//
//  PersonalScheduleViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit
import FSCalendar

class PersonalScheduleViewController: UIViewController {
    
    var timer: Timer?
    static var date = Date()
    
    static var startMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: PersonalScheduleViewController.date)))!
    
    var selectedDate : String = ""
    
//    //test
//    var datesWithEvent = ["2020-01-03", "2020-01-05", "2020-01-07", "2020-01-10", "2020-01-15", "2020-01-21", "2020-01-26", "2020-01-29"]
//    //test
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Updates.getStaffList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimer()
        setCalendar() // calendar settings
        setNav()
    }

    func setNav(){
        navigationItem.title = "班表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        }
    
    func setCalendar(){
        let calendar = FSCalendar(frame: CGRect(x: 5, y: 100, width: view.frame.width-10, height: view.frame.height-200))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        view.addSubview(calendar)
        calendar.allowsMultipleSelection = false
        
        calendar.appearance.weekdayTextColor = UIColor(named : "Color3")
        calendar.appearance.headerTitleColor = UIColor(named : "Color3")
        calendar.appearance.selectionColor = UIColor(named : "Color5")
        calendar.appearance.todayColor = UIColor(named : "Color7")
        calendar.appearance.todaySelectionColor = UIColor(named : "Color1")
        calendar.appearance.eventDefaultColor = UIColor(named : "Color1")
        calendar.appearance.eventSelectionColor = UIColor(named : "Color7")
        
        self.calendar = calendar
        
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopTimer), userInfo: nil, repeats: true)
    }
    
    var countStop = 0
    @objc func stopTimer() {
        Updates.getMonthData(calendar : calendar)
        countStop += 1
        if countStop == 3{
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
    }
    
}

extension PersonalScheduleViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    //data source
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        selectedDate = "\(self.dateFormatter.string(from: date))"
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        
        let date1 = selectedDate.components(separatedBy: "-")
        let year = date1[0]
        let month = date1[1]
        
        // get dateID
        let api1 = "/search/calendar/" + year + "/" + month
        NetWorkController.sharedInstance.get(api: api1){(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    if companyJson["date"].string == self.selectedDate{
                        TakeLeaveController.dateID = companyJson["dateID"].int
                    }
                }
                self.jumpToDayView()
            }
        }
        
        TakeLeaveController.selectedDate = "\(self.dateFormatter.string(from: date))"
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
            
        }
    }
    
    func jumpToDayView(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navPersonalDayViewController")
        present(controller, animated: true, completion: nil)
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did Deselect date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "今"
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for i in Global.eventDotsArr{
            if self.dateFormatter.string(from: date) == i{
                return 1
            }
        }
        return 0
    }
    
    
    //delegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel?.frame.origin.y = calendar.frame.maxY + 10
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        Updates.getMonthData(calendar : calendar)
    }
    
}
