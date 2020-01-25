//
//  ScheduleViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//
//班表總覽

import UIKit
import FSCalendar

class ScheduleViewController: UIViewController {
    
    var timerGetMonthData: Timer?
    var timerUpdateCalendar: Timer?
    var dailyManPower : Array<Int>?
    var dailyStaffDemend : Array<Int>?
    static var selectedDate : String?
//    var selected : Int?
    
    //for DayViewModel
    static var date = Date()
    static var startMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: ScheduleViewController.date)))!
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    var selectedStaff = ""
    
    //test
    var datesWithEvent = ["2020-01-03", "2020-01-05", "2020-01-07", "2020-01-10", "2020-01-15", "2020-01-21", "2020-01-26", "2020-01-29"]
    //test
    
    //Used in one of the example methods
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    @IBAction func toggle(_ sender: UIBarButtonItem) {
        let scope: FSCalendarScope = (calendar.scope == .month) ? .week : .month
        self.calendar.setScope(scope, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimer()
        registerNib()
        getMonthData()
        setNav()
        setCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //讓初始為collectionView第一個選項
//        let indexPathForFirstRow = IndexPath(row: selected, section: 0)
//        collectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [])
        
    }
    override func viewDidDisappear(_ animated: Bool) {
         // 將timer的執行緒停止
         if self.timerGetMonthData != nil {
              self.timerGetMonthData?.invalidate()
         }
        if self.timerUpdateCalendar != nil {
             self.timerUpdateCalendar?.invalidate()
        }
        
    }
    
    
    func setTimer(){
        self.timerGetMonthData = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getMonthData), userInfo: nil, repeats: true)
        self.timerUpdateCalendar = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
    }
    
    var reloadOnce = false
    @objc func reload(){
        if !reloadOnce{
            collectionView.reloadData()
            reloadOnce = true
        }
        calendar.reloadData()
    }
    
    // for collection view registration
    
    func setNav(){
        navigationItem.title = "班表總覽"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true

    }
    
    func setCalendar(){
        let calendar = FSCalendar(frame: CGRect(x: 5, y: 150, width: view.frame.width-10, height: view.frame.height-300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        view.addSubview(calendar)
        calendar.allowsMultipleSelection = false;
        
        calendar.appearance.weekdayTextColor = UIColor(named : "Color3")
        calendar.appearance.headerTitleColor = UIColor(named : "Color3")
        calendar.appearance.selectionColor = UIColor(named : "Color5")
        calendar.appearance.todayColor = UIColor(named : "Color7")
        calendar.appearance.todaySelectionColor = UIColor(named : "Color1")
        calendar.appearance.eventDefaultColor = UIColor(named : "Color1")
        calendar.appearance.eventSelectionColor = UIColor(named : "Color3")
        
        self.calendar = calendar
    }
    
    
    // 從後端把所有當月班表撈出來
    @objc func getMonthData(){
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
        
        let abs = Global.companyInfo!.ltdID
        
        var a = ""
        if let abs = Global.companyInfo!.ltdID{
            a += "/search/schedule/" + year + "/" + month + "/\(abs)"
            print(a)
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
                self.seeNotEnoughDates()
            }
        }
    }
    
    //把Global.companyShiftDateList資料也建好
    func setCompanyShiftDateList(dateArr : Array<ShiftDate>){
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
        calendar.updateFocusIfNeeded()
    }
    
    //原本要做人數不夠標記紅點的方法，但時間關係目前改為製作已排班日期標記紅點
    func seeNotEnoughDates(){
        dailyManPower = Array(repeating : 0, count : countOfDaysInCurrentMonth())
        dailyStaffDemend = Array(repeating : 0, count : countOfDaysInCurrentMonth())
        let daysinMonth = countOfDaysInCurrentMonth()
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
            
            if dailyManPower![i] > 0{
                let theDay = dateFormatter.string(from: calendar.currentPage.startOfDay.add(component: .day, value: i-1))
                Global.eventDotsArr.append(theDay)
                print("LLL" + theDay)
            }
            
        }
    }
    
    func countOfDaysInCurrentMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for:  self.calendar.currentPage)
        return (range?.length)!
    }
}

extension ScheduleViewController :  UICollectionViewDataSource, UICollectionViewDelegate{
    
    func registerNib() {
        
        // register cell
        collectionView.register(UINib(nibName: StaffCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: StaffCollectionViewCell.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
            return Global.staffList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,for: indexPath) as? StaffCollectionViewCell {
                let name = Global.staffList[indexPath.row].name
                cell.configureCell(name: name)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(collectionView, didSelectItemAt: cell, isSelected: false)
                return cell
            }
            return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        if selectedCell != nil {
            changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: true)
            selectedStaff = Global.staffList[indexPath.item].name
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell:UICollectionViewCell? = self.collectionView.cellForItem(at: indexPath)
        if selectedCell != nil {
            changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: false)
        }
    }
    
    func changeCellColor(_ collectionView: UICollectionView, didSelectItemAt cell: UICollectionViewCell, isSelected : Bool){
        if isSelected {
            cell.contentView.backgroundColor = UIColor(named : "Color6")
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
}

extension ScheduleViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    //data source
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
//        DayViewController.selectedDate = "\(self.dateFormatter.string(from: date))"
        
        //example
        let selected = "\(self.dateFormatter.string(from: date))"
        //example
        ScheduleViewController.selectedDate = selected
        
        jumpToDayView()
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
        // 修改成有班表的日期要有點點
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
    
    func jumpToDayView(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navDayViewController")
        
         present(controller, animated: true, completion: nil)
            
    }
}
