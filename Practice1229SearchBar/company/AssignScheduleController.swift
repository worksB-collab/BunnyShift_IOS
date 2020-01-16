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
    
    var selectedDate : String?
    
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
        staffSelected = ItemSelection(names)
        shiftSelected = ItemSelection(Global.getCertainTypeShifts(typeName : "weekday"))//假設為某一天的日別
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
        registerNib()
        calendarSettings() // calendar settings
        setNav()
        setTableView()
        
    }
    
    // for collection view registration
    
    func setNav(){
        navigationItem.title = "班表排程設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func calendarSettings(){
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
    var names = Global.staffNameList
    var staffSelected : ItemSelection
    var shiftSelected : ItemSelection
    
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
    
}

extension AssignScheduleController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
        
        if collectionView == self.collectionView{
            return names.count
        }else{
            return Global.getCertainTypeShifts(typeName : "weekday").count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,for: indexPath) as? StaffCollectionViewCell {
                let name = names[indexPath.row]
                cell.configureCell(name: name)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(cell, didSelectItemAt: indexPath)
                return cell
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShiftCollectionViewCell.reuseIdentifier,for: indexPath) as? ShiftCollectionViewCell {
                let name = Global.getCertainTypeShifts(typeName : "weekday")[indexPath.row]
                cell.configureCell(name: name)
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
        }else{
            shiftSelected.selected[indexPath.item] = true
            let selectedCell:UICollectionViewCell = self.shiftCollectionView.cellForItem(at: indexPath)!
            changeCellColor(selectedCell, didSelectItemAt: indexPath)
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
        return 2
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 //需要依據當天為平日或假日給予不同的array
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DayViewTableViewCell"
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DayViewTableViewCell
        
        cell1.backgroundColor = UIColor(named: "Color1")
        //  待填寫每個被按到當天的資料
        if selectedDate == "" || selectedDate == nil{
            selectedDate = "0-0-0"
        }
//        var date = selectedDate?.split(separator: "-")
        let date = selectedDate?.components(separatedBy: "-")
        let year = date![0]
        var month = date![1]
        var day = date![2]
        var shiftArr = Array<String>()
        shiftArr.append("Johanna")
        shiftArr.append("Katie")
        var timeShiftName : [String : Array<String>] = ["weekday" : shiftArr]
        // 待填寫
        
        Global.companyInfo = Company("name", "0928", "new taipei", "817227386", "23")
        let a = "/search/schedule/" + year + "/" + month
        let b = "/" + Global.companyInfo!.ltdID
        
        NetWorkController.sharedInstance.get(api: a+b)
        {(jsonData) in
            
            
        }
        
//        let departureLat = jsonData[i]["departureLat"].double
        
        //test data
        cell1.configureCell(dateShift: "weekday", staffNum: 5, startTime: "22:00", endTime: "12:00", staffs: timeShiftName["weekday"]!)
        // test
        
//        cell1.dateShift.text = "weekday"
//        cell1.staffNum.text = "5"
//        cell1.startTime.text = "12:00"
//        cell1.endTime.text = "22:00"
//
//        var s : String = ""
//        for i in timeShiftName["weekday"]!{
//            if s != ""{
//                s += ", " + i
//            }
//            s += i
//        }
//
//        cell1.staffs!.text = s
        
        
        
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
        selectedDate = "\(selectedDates)"
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
