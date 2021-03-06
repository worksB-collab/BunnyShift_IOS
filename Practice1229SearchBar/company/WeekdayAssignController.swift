//
//  WeekdayAssignController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/9.
//  Copyright © 2020 cm0521. All rights reserved.
//
//每週日別設定

import UIKit

class WeekdayAssignController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var selectedWeekday : String?
    var selectedDayType : String?
    var dateCount : Int
    var selected : Int = 0 // 預設選第一個
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func save(_ sender: RoundRecButton) {
        for i in Global.dayType{
            if i == ""{
                Toast.showToast(self.view, "請選擇每天的班別")
                return
            }
        }
        searchAndScheduleAPI()
        NetWorkController.sharedInstance.postT(api: "/schedule/setweekshift", params: ["monday": Global.dayType[0], "tuesday": Global.dayType[1],"wednesday": Global.dayType[2], "thursday": Global.dayType[3],"friday": Global.dayType[4], "saturday": Global.dayType[5],"sunday": Global.dayType[6], "ltdID": Global.companyInfo?.ltdID])
        {(jsonData) in
            print(jsonData.description)
            if jsonData["Status"].string == "200"{
                self.searchAndScheduleAPI()
                
            }
        }
        jumpToSchedule()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPathForFirstRow = IndexPath(row: selected, section: 0)
        collectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        dateCount = 0
        super.init(coder: aDecoder)
    }
    
    
    func setNav(){
        navigationItem.title = "每週日別設定"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    func jumpToSchedule(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "companyMain")
        present(controller, animated: true, completion: nil)
        
    }
    
    func searchAndScheduleAPI(){
        let date = self.dateFormatter.string(from: Date()).components(separatedBy: "-")
        let year = date[0]
        let month = date[1]
        
        var dateIDs = Array<Int>() // 整個月的ＩＤ
        
        // get dateID
        let api1 = "/search/calendar/" + year + "/" + month
        NetWorkController.sharedInstance.get(api: api1){(jsonData) in
            if jsonData["Status"].string == "200"{
                let arr = jsonData["rows"]
                for i in 0 ..< arr.count{
                    let companyJson = arr[i]
                    let dateID = companyJson["dateID"].int
                    dateIDs.append(dateID!)
                }
                // arr為目前有的日別
                for i in dateIDs{
                    let firstDay = Date().startOfDay
                    let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self.dateFormatter.date(from: self.dateFormatter.string(from: firstDay))!)
                    let weekday = dateComponents.weekday!
                    
                    var arr = Array<String>()
                    var matched = false
                    for i in Global.shiftDateNames{
                        for j in arr{
                            if i == j{
                                matched = true
                            }
                        }
                        if !matched{
                            arr.append(i)
                        }
                        matched = false
                    }
                    for j in 0 ..< Global.companyShiftDateList[Global.dayType[weekday-1]]!!.count{
                        
                        var params: Dictionary<String, String> = [:]
                        var arr = [Any]()
                        if let dateShiftName = Global.companyShiftDateList[Global.dayType[weekday-1]]??[j].dateName{
                            if let timeShiftName = Global.companyShiftDateList[Global.dayType[weekday-1]]??[j].timeName{
                                if let startTime = Global.companyShiftDateList[Global.dayType[weekday-1]]??[j].startTime{
                                    if let endTime = Global.companyShiftDateList[Global.dayType[weekday-1]]!![j].endTime{
                                        if let staffNumber = Global.companyShiftDateList[Global.dayType[weekday-1]]!![j].staffNum{
                                            params = ["dateShiftName": "\(dateShiftName)", "timeShiftName" : "\(timeShiftName)", "startTime" : "\(startTime)", "endTime" : "\(endTime)", "staffNumber" : "\(staffNumber)"]
                                        }
                                    }
                                }
                            }
                        }
                        arr.append(params)
                        let data = ["data" : arr]
                        print(data)
                        NetWorkController.sharedInstance.postT(api: "/schedule/setschedule", params: data){(jsonData) in
                            if jsonData["Status"].string == "200"{
                                let msg = jsonData["message"].string
                                print(msg!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func countOfDaysInCurrentMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for:  Date())
        return (range?.length)!
    }
    
    // collection view
    var weekDayNames = ["週一", "週二", "週三", "週四", "週五", "週六", "週日"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func registerNib() {
        
        //first cv
        collectionView?.register(UINib(nibName: WeekdayCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: WeekdayCollectionViewCell.reuseIdentifier)
        collectionView?.contentInsetAdjustmentBehavior = .never
        
        //tableView
        self.tableView?.register(UINib(nibName: "ShiftSetTableViewCell", bundle: nil), forCellReuseIdentifier: "ShiftSetTableViewCell")
        
        tableView.allowsMultipleSelection = false
        
        //隱藏cell灰色底線
        tableView?.tableFooterView = UIView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
        return weekDayNames.count
    }
    
    var viewAppear = true
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.reuseIdentifier,for: indexPath) as? WeekdayCollectionViewCell {
            let name = weekDayNames[indexPath.row]
            cell.configureCell(name: name)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = cell.frame.height/2
            if viewAppear{
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                viewAppear = false
            }
            changeCellColor(collectionView, didSelectItemAt: cell, isSelected: indexPath.item == selected ? true : false)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        let selectedCell: WeekdayCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! WeekdayCollectionViewCell
        changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: true)
        selectedWeekday = selectedCell.nameLabel.text
        
        var indexP : IndexPath?
        for i in tableView!.visibleCells{
            let cell = i as! ShiftSetTableViewCell
            indexP = tableView.indexPath(for: cell)
            tableView.deselectRow(at: indexP!, animated: true)
            tableView.cellForRow(at: indexP!)?.contentView.backgroundColor = UIColor.clear
            if Global.dayType[indexPath.item] == cell.dateName.text{
                tableView.selectRow(at: indexP, animated: true, scrollPosition: .top)
                tableView.cellForRow(at: indexP!)?.contentView.backgroundColor = UIColor(named : "Color1")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: false)
    }
    
    func changeCellColor(_ collectionView: UICollectionView, didSelectItemAt cell: UICollectionViewCell, isSelected : Bool){
        if isSelected {
            cell.contentView.backgroundColor = UIColor(named : "Color7")
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
}

extension WeekdayAssignController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.companyShiftDateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ShiftSetTableViewCell"
        // 把 tableView 中叫 datacell 的畫面部分跟 TestTableViewCell 類別做連結
        // 用 as！轉型(轉成需要顯示的cell : TestTableViewCell)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShiftSetTableViewCell
        
        let list = Global.companyShiftDateList
        print("indexPath.row" , indexPath.row)
        let key = Global.shiftDateNames[indexPath.row]
        
        var timeString = ""
        var startString = ""
        var dashString = ""
        var endString = ""
        var staffNumString = ""
        for i in 0 ..< list![key]!!.count{
            timeString += list![key]!![i].timeName + "\n"
            startString += list![key]!![i].startTime! + "\n"
            dashString += "-\n"
            endString += list![key]!![i].endTime! + "\n"
            staffNumString += "\(list![key]!![i].staffNum!)  人\n"
            
        }
        
        cell1.configureCell(dateName: key, timeName: timeString, startTime: startString, dash : dashString, endTime: endString, staffNum: staffNumString)
        
        cell1.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        cell1.layer.shadowOffset = CGSize(width: 2, height: 7)
        cell1.layer.shadowOpacity = 2
        cell1.layer.shadowRadius = 2
        cell1.layer.masksToBounds = false
        
        return cell1
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected" , indexPath.item)
        let cell1 = tableView.cellForRow(at: indexPath) as! ShiftSetTableViewCell
        
        for i in 0 ..< weekDayNames.count{
            if weekDayNames[i] == selectedWeekday{
                Global.dayType[i] = cell1.dateName.text!
            }
        }
        
        cell1.contentView.backgroundColor = UIColor (named : "Color1")
        selectedDayType = cell1.dateName.text!
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! ShiftSetTableViewCell
        
        cell1.contentView.backgroundColor = UIColor.clear
    }
}

