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

    var selectedDate : String = ""
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
//        Toast.showToast(self.view, "已成功送出申請") // 沒用啊靠
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setCalendar() // calendar settings
        setNav()
    }

    func setNav(){
        navigationItem.title = "排班表"
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
        
        self.calendar = calendar
        
    }
    
}

extension PersonalScheduleViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    //data source
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("did select date \(self.dateFormatter.string(from: date))")
            let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
            print("selected dates is \(selectedDates)")
            
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navPersonalDayViewController")
                present(controller, animated: true, completion: nil)
            
            TakeLeaveController.selectedDate = "\(self.dateFormatter.string(from: date))"
            
            if monthPosition == .next || monthPosition == .previous {
                calendar.setCurrentPage(date, animated: true)
            }
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
            return 2
        }
        
        
        //delegate
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel?.frame.origin.y = calendar.frame.maxY + 10
        
        }
    }
