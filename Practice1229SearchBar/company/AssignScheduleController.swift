//
//  AssignScheduleController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//
//班表排程設定

import UIKit
import FSCalendar
import SwiftyJSON

class AssignScheduleController: UIViewController{
    
    var selectedStaff : String?
    var selectedShift : String?
    var selectedDate : String?
    var dateID : Int?
    var dateShiftName : String?
    var shiftNameArr = Array<String>() //shift names
    var isMatched = false
    var shiftStaffArr = Array<Array<String>>()//related with shiftNameArr on staff who has to work
    
    
    var selected : Int = 0
    var dailyShiftArr = Array<String>()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    let tableView = UITableView()
    //    @IBOutlet weak var tableView: UITableView!
    
    fileprivate weak var eventLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        jumpToSchedule()
    }
    
    @IBAction func toggle(_ sender: UIBarButtonItem) {
        let scope: FSCalendarScope = (calendar.scope == .month) ? .week : .month
        self.calendar.setScope(scope, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShiftNameArr()
        getdailyShiftArr()
        registerNib()
        setCalendar()
        setNav()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //讓初始為collectionView第一個選項
//        let indexPathForFirstRow = IndexPath(row: selected, section: 0)
//        collectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [])
//        shiftCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [])
        
    }
    
    func setNav(){
        navigationItem.title = "班表排程設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func setCalendar(){
        let calendar = FSCalendar(frame: CGRect(x: 5, y: 200, width: view.frame.width-10, height: view.frame.height-400))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        calendar.allowsMultipleSelection = true;
        calendar.swipeToChooseGesture.isEnabled = true
        view.addSubview(calendar)
        
        calendar.appearance.weekdayTextColor = UIColor(named : "Color3")
        calendar.appearance.headerTitleColor = UIColor(named : "Color3")
        calendar.appearance.selectionColor = UIColor(named : "Color5")
        calendar.appearance.todayColor = UIColor(named : "Color7")
        calendar.appearance.todaySelectionColor = UIColor(named : "Color1")
        calendar.appearance.eventDefaultColor = UIColor(named : "Color1")
        calendar.appearance.eventSelectionColor = UIColor(named : "Color3")
        
        self.calendar = calendar
        
    }
    
    func setTableView(){
        view.addSubview(tableView)
        self.tableView.register(DayViewTableViewCell.self, forCellReuseIdentifier: "DayViewTableViewCell")
        tableView.frame = CGRect(x: 10, y: 700, width: view.frame.width-20, height: view.frame.height-750);
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        
        //隱藏cell灰色底線
        tableView.tableFooterView = UIView()
    }
    
    // collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shiftCollectionView: UICollectionView!
    
    func registerNib() {
        
        // register cell
        collectionView.register(UINib(nibName: StaffCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: StaffCollectionViewCell.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // register cell
        shiftCollectionView.register(UINib(nibName: ShiftCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: ShiftCollectionViewCell.reuseIdentifier)
        
        shiftCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func jumpToSchedule(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "companyMain")
        present(controller, animated: true, completion: nil)
        
    }
    
    func getDateData(){
        let date = selectedDate?.components(separatedBy: "-")
        let year = date![0]
        var month = date![1]
        var day = date![2]
        
        // get dateID
        let a = "/search/calendar/" + year + "/" + month
        print(a)
        NetWorkController.sharedInstance.get(api: a){(jsonData) in
            print(a)
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let ltdID = companyJson["ltdID"].string
                    if companyJson["date"].string == self.selectedDate{
                        self.dateID = companyJson["dateID"].int
                    }
                }
                // get how many shifts and staffs working on certain date
                let b = "/search/schedulebydate/\(self.dateID!)\(Global.companyInfo?.ltdID)"
                print(b)
                NetWorkController.sharedInstance.get(api: b)
                {(jsonData) in
                    if jsonData["Status"].string == "200"{
                        let arr = jsonData["rows"]
                        for i in 0 ..< arr.count{
                            let companyJson = arr[i]
                            self.dateShiftName = companyJson["dateShiftName"].string
                            for j in self.shiftNameArr{
                                if j == companyJson["timeShiftName"].string!{
                                    self.isMatched = true
                                }
                            }
                            if self.isMatched == false{
                                self.shiftNameArr.append(companyJson["timeShiftName"].string!)
                                var currentShift = Array<String>()
                                self.shiftStaffArr.append(currentShift)
                            }
                            for k in 0..<self.shiftNameArr.count{
                                if companyJson["timeShiftName"].string == self.shiftNameArr[k]{
                                    self.shiftStaffArr[k].append(companyJson["staffName"].string!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadCertainDay(){ // 點擊某日的時候，call this func 把當日班別撈出來
        
        
    }
    

    func setShiftNameArr(){
        if shiftNameArr.count == 0 {
            shiftNameArr = Global.shiftDateNames
        }
    }
    
    func getdailyShiftArr(){
        // get all shifts
        
        for i in 0 ..< Global.companyShiftDateList.count{
            for j in Global.companyShiftDateList![shiftNameArr[i]]!!{
                let currentShift = ShiftDate(j.dateName, j.timeName)
                Global.dailyShiftArr.append(currentShift)
            }
        }
        for i in Global.dailyShiftArr{
            self.dailyShiftArr.append(i.timeName)
        }
    }
    
}

extension AssignScheduleController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            return Global.staffList.count
        }else{
            return Global.shiftDateNames.count// 依照日期給定某日別的班別
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,for: indexPath) as? StaffCollectionViewCell {
                let name = Global.staffList[indexPath.row].name
                cell.configureCell(name: name)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(collectionView, didSelectItemAt: cell, isSelected: false)
                return cell
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShiftCollectionViewCell.reuseIdentifier,for: indexPath) as? ShiftCollectionViewCell {
                cell.configureCell(dateShift: Global.dailyShiftArr[indexPath.row].dateName, timeShift: Global.dailyShiftArr[indexPath.row].timeName)
                
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(collectionView, didSelectItemAt: cell, isSelected: false)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView{
            let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
            changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: true)
            selectedStaff = Global.staffList[indexPath.item].name
            
            
        }else{
            let selectedCell:UICollectionViewCell = self.shiftCollectionView.cellForItem(at: indexPath)!
            changeCellColor(collectionView, didSelectItemAt: self.shiftCollectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: true)
            selectedShift = Global.shiftTimeNames[indexPath.item]
        }
        if selectedStaff != nil , selectedShift != nil{
            showCurrentSelection()
        }
    }
    
    //顯示已選班別跟人員的目前上班日期
    func showCurrentSelection(){

        calendar.allowsSelection = true
        var selectedDates = calendar.selectedDates
        for i in 0 ..< calendar!.selectedDates.count{
            calendar.deselect(calendar!.selectedDates[i])
            selectedDates.removeAll()
        }
        for i in 0 ..< Global.monthlyShiftArr!.count{
            let arr = Global.monthlyShiftArr?[i]
            print("sd \(arr?.staffName) \(selectedStaff) \(arr?.timeName) \(selectedShift)")
            if arr?.staffName == selectedStaff , arr?.timeName == selectedShift{
                selectedDates.append(dateFormatter.date(from: arr!.date!)!)
            }
        }
        calendar.select(selectedDates[0])
        let sd = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("sd \(sd)")
        calendar.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let selectedCell:UICollectionViewCell? = self.collectionView.cellForItem(at: indexPath)
            if selectedCell != nil {
                changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: false)
            }
        }else{
            let selectedCell:UICollectionViewCell? = self.shiftCollectionView.cellForItem(at: indexPath)
            if selectedCell != nil {
                changeCellColor(collectionView, didSelectItemAt: self.shiftCollectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: false)
            }
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

extension AssignScheduleController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shiftNameArr.count //需要依據當天為平日或假日給予不同的array
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DayViewTableViewCell"
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DayViewTableViewCell
        
        cell1.backgroundColor = UIColor(named: "Color1")
        //  待填寫每個被按到當天的資料
        if selectedDate == "" || selectedDate == nil{
            return UITableViewCell()
            
        }
        
        var currentShift = Global.companyShiftDateList[dateShiftName!]!![indexPath.item]
        
        cell1.configureCell(dateShift: shiftNameArr[indexPath.item], staffNum: currentShift.staffNum!, startTime: currentShift.startTime!, endTime: currentShift.endTime!, staffs: shiftStaffArr[indexPath.item])
        
        //小倩的範例
        //        let departureLat = jsonData[i]["departureLat"].double
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected" , indexPath.item)
        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
        
        
        cell1.backgroundColor = UIColor (named : "Color1")
        cell1.tintColor = UIColor (named : "Color5")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! DayViewTableViewCell
        
        cell1.backgroundColor = UIColor.clear
    }
    
}


extension AssignScheduleController : FSCalendarDataSource, FSCalendarDelegate{
    
    
    //data source
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        selectedDate = "\(self.dateFormatter.string(from: date))"
        getDateData()
        
        if selectedShift == nil || selectedStaff == nil {
            calendar.allowsMultipleSelection = false
            Toast.showToast(self.view, "請點選上兩排資訊以開始排班")
        }else{
            calendar.allowsMultipleSelection = true
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
}
