//
//  DateShiftAssignController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/9.
//  Copyright © 2020 cm0521. All rights reserved.
//
//每週日別設定

import UIKit

class DateShiftAssignController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var dateCount : Int
    var selected : Int = 0
    var selectedArr  = Array(repeating: "", count: 7)
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func save(_ sender: RoundRecButton) {
        Global.dayType = selectedArr
        
        NetWorkController.sharedInstance.postT(api: "/schedule/setweekshift", params: ["monday": selectedArr[0], "tuesday": selectedArr[1],"wednesday": selectedArr[2], "thursday": selectedArr[3],"friday": selectedArr[4], "saturday": selectedArr[5],"sunday": selectedArr[6], "ltdID": Global.companyInfo?.ltdID])
        {(jsonData) in
            print(jsonData.description)
            
            
        }
        
        jumpToSchedule()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setNav()
        
        //test
        Global.shiftDateNames.append("ada")
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    func jumpToSchedule(){
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "companyMain")
        present(controller, animated: true, completion: nil)
        
    }
    
    
    // collection view
    var weekDayNames = ["週一", "週二", "週三", "週四", "週五", "週六", "週日"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func registerNib() {
        
        // register cell
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.reuseIdentifier,for: indexPath) as? WeekdayCollectionViewCell {
            let name = weekDayNames[indexPath.row]
            cell.configureCell(name: name)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = cell.frame.height/2
            changeCellColor(collectionView, didSelectItemAt: cell, isSelected: indexPath.item == selected ? true : false)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeCellColor(collectionView, didSelectItemAt: self.collectionView.cellForItem(at: indexPath) as! UICollectionViewCell, isSelected: false)
    }
    
    func changeCellColor(_ collectionView: UICollectionView, didSelectItemAt cell: UICollectionViewCell, isSelected : Bool){
        if isSelected {
            cell.contentView.backgroundColor = UIColor(named : "Color6")
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
}

extension DateShiftAssignController : UITableViewDelegate, UITableViewDataSource{
    
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
        
        selectedArr[indexPath.item] = cell1.dateName.text!
        cell1.contentView.backgroundColor = UIColor (named : "Color1")
//        cell1.backgroundColor = UIColor (named : "Color1")
//        cell1.tintColor = UIColor (named : "Color5")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! ShiftSetTableViewCell
        
        cell1.contentView.backgroundColor = UIColor.clear
    }
}

