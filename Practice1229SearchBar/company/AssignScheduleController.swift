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
    var date_shift_name : String?
    var shiftNameArr = Array<String>() //shift names
    var isMatched = false
    var shiftStaffArr = Array<Array<String>>()//related with shiftNameArr on staff who has to work
    //    var allDateNames : [String] = []
    //    var allTimeNames : [String] = []
    
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
        staffSelected = ItemSelection(Global.staffNameList)
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
        getAllShifts()
        registerNib()
        setCalendar() // calendar settings
        setNav()
        setTableView()
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
        view.addSubview(calendar)
        calendar.allowsMultipleSelection = true;
        
        calendar.appearance.weekdayTextColor = UIColor(named : "Color3")
        calendar.appearance.headerTitleColor = UIColor(named : "Color3")
        calendar.appearance.selectionColor = UIColor(named : "Color5")
        calendar.appearance.todayColor = UIColor(named : "Color7")
        calendar.appearance.todaySelectionColor = UIColor(named : "Color1")
        
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
        
        //        tableView.translatesAutoresizingMaskIntoConstraints = false
        //        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        //        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        //        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        //        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        //        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        //        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        //        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        //        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    // collection view
    var staffSelected : ItemSelection
    var shiftSelected = ItemSelection()
    
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
                    let ltdID = companyJson["ltd_id"].string
                    if companyJson["date"].string == self.selectedDate{
                        self.dateID = companyJson["date_id"].int
                    }
                }
                // get how many shifts and staffs working on certain date
                let b = "/search/schedulebydate/\(self.dateID!)"
                print(b)
                NetWorkController.sharedInstance.get(api: b)
                {(jsonData) in
                    if jsonData["Status"].string == "200"{
                        let arr = jsonData["rows"]
                        for i in 0 ..< arr.count{
                            let companyJson = arr[i]
                            self.date_shift_name = companyJson["date_shift_name"].string
                            for j in self.shiftNameArr{
                                if j == companyJson["time_shift_name"].string!{
                                    self.isMatched = true
                                }
                            }
                            if self.isMatched == false{
                                self.shiftNameArr.append(companyJson["time_shift_name"].string!)
                                var currentShift = Array<String>()
                                self.shiftStaffArr.append(currentShift)
                            }
                            for k in 0..<self.shiftNameArr.count{
                                if companyJson["time_shift_name"].string == self.shiftNameArr[k]{
                                    self.shiftStaffArr[k].append(companyJson["staff_name"].string!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAllShifts(){
        // get all shifts
        
        print("123456789! \(Global.companyShiftDateList.count)")
        for i in 0 ..< Global.companyShiftDateList.count{
            for j in Global.companyShiftDateList![shiftNameArr[i]]!!{
                var currentShift = ShiftDate(j.dateName, j.timeName)
                Global.allShifts.append(currentShift)
                //                allDateNames.append(j.dateName)
                //                allTimeNames.append(j.timeName)
            }
        }
        var allShifts = Array<String>()
        for i in Global.allShifts{
            allShifts.append(i.timeName)
        }
        shiftSelected = ItemSelection(allShifts)
    }
    
    func getMonthData(){
        let date = selectedDate?.components(separatedBy: "-")
        let year = date![0]
        var month = date![1]
        var day = date![2]
        
        // get dateID
        let a = "/search/schedule/" + year + "/" + month
        
        NetWorkController.sharedInstance.get(api: a){(jsonData) in
            print(a)
            var dateArr = Array<ShiftDate>()
            var matchDate = false
            var match_date_shift_name = false
            var match_time_shift_name = false
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let date = companyJson["date"].string
                    let date_shift_name = companyJson["date_shift_name"].string
                    let time_shift_name = companyJson["time_shift_name"].string
                    let start_time = companyJson["start_time"].string
                    let end_time = companyJson["end_time"].string
                    let staffNum = companyJson["number"].int
                    for i in dateArr{
                        if date == i.date{
                            matchDate = true
                            if date_shift_name == i.dateName{
                                match_date_shift_name = true
                                if time_shift_name == i.timeName{
                                    match_time_shift_name = true
                                }
                            }
                        }
                    }
                    if matchDate && match_date_shift_name && match_time_shift_name{
                        var currentSD = ShiftDate(date_shift_name!, time_shift_name!)
                        currentSD.date = date
                        currentSD.
                            
                     
                    }else{
                        return
                    }
                    if date == self.selectedDate{
                        self.dateID = companyJson["date_id"].int
                    }
                }
            }
        }
    }
}

extension AssignScheduleController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            return Global.staffNameList.count
        }else{
            return shiftSelected.list.count// 依照日期給定某日別的班別
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,for: indexPath) as? StaffCollectionViewCell {
                let name = Global.staffNameList[indexPath.row]
                cell.configureCell(name: name)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(cell, didSelectItemAt: indexPath)
                return cell
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShiftCollectionViewCell.reuseIdentifier,for: indexPath) as? ShiftCollectionViewCell {
                
                let dateShift =  Global.getCertainTypeShifts(typeName : date_shift_name!)[indexPath.row]
                let timeShift = Global.companyShiftDateList[Global.getCertainTypeShifts(typeName : date_shift_name!)[indexPath.row]]
                
                
                // 依照日期給定某日別的班別
                cell.configureCell(dateShift: Global.allShifts[indexPath.row].dateName, timeShift: Global.allShifts[indexPath.row].timeName)
                
                print("123456789?" + Global.allShifts[indexPath.row].dateName + "," + Global.allShifts[indexPath.row].timeName)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(cell, didSelectItemAt: indexPath)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView{
            staffSelected.selected[indexPath.item] = true
            let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
            changeCellColor(selectedCell, didSelectItemAt: indexPath)
            selectedStaff = staffSelected.list[indexPath.item]
            
            
        }else{
            shiftSelected.selected[indexPath.item] = true
            let selectedCell:UICollectionViewCell = self.shiftCollectionView.cellForItem(at: indexPath)!
            changeCellColor(selectedCell, didSelectItemAt: indexPath)
            selectedShift = Global.shiftDateNames[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            staffSelected.selected[indexPath.item] = false
            let selectedCell:UICollectionViewCell? = self.collectionView.cellForItem(at: indexPath)
            if selectedCell != nil {
                changeCellColor(selectedCell, didSelectItemAt: indexPath)
            }
        }else{
            shiftSelected.selected[indexPath.item] = false
            let selectedCell:UICollectionViewCell? = self.shiftCollectionView.cellForItem(at: indexPath)
            if selectedCell != nil {
                changeCellColor(selectedCell, didSelectItemAt: indexPath)
            }
        }
    }
    
    func changeCellColor(_ cell: UICollectionViewCell?, didSelectItemAt indexPath: IndexPath){
        
        if cell is StaffCollectionViewCell{
            if staffSelected.selected[indexPath.item]{
                //            selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
                cell?.contentView.backgroundColor = UIColor(named : "Color6")
                print(indexPath.item , "selected")
            }else{
                cell?.contentView.backgroundColor = UIColor.clear
                print(indexPath.item , "deselected")
            }
        }else{
            if shiftSelected.selected[indexPath.item]{
                //            selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
                cell?.contentView.backgroundColor = UIColor(named : "Color6")
                print(indexPath.item , "selected")
            }else{
                cell?.contentView.backgroundColor = UIColor.clear
                print(indexPath.item , "deselected")
            }
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
        
        var currentShift = Global.companyShiftDateList[date_shift_name!]!![indexPath.item]
        
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
        return 2
    }
    
    //delegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel?.frame.origin.y = calendar.frame.maxY + 10
        
    }
}
