//
//  DateShiftAssignController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/9.
//  Copyright © 2020 cm0521. All rights reserved.
//
//每週日別設定

import UIKit

class DateShiftAssignController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var dateCount : Int
    var matchName : String
    var dayType = Array(repeating: Global.shiftDateNames[0], count: 7)
    
 
    @IBOutlet weak var tableView: UITableView!
    @IBAction func save(_ sender: RoundRecButton) {
        Global.dayType = dayType
        
        NetWorkController.sharedInstance.postT(api: "/schedule/setweekshift", params: ["monday": dayType[0], "tuesday": dayType[1],"wednesday": dayType[2], "thursday": dayType[3],"friday": dayType[4], "saturday": dayType[5],"sunday": dayType[6], "ltdID": Global.companyInfo?.ltdID])
                    {(jsonData) in
                        
                        
                        
                        
        }

        jumpToSchedule()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setNav()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        dateSelected = ItemSelection(weekDayNames)
        dateCount = 0
        matchName = ""
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
    var dateSelected : ItemSelection
    
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
                    return cell
                }
                return UICollectionViewCell()
        }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateSelected.selected[indexPath.item] = true
        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        changeCellColor(selectedCell, didSelectItemAt: indexPath)
        
        
//        for i in 0..<Global.shiftDateNames.count{
//            let cell = tableView.visibleCells[i]
//            cell.backgroundColor = UIColor.clear
//            if dayType[indexPath.item] == Global.shiftDateNames[i]{
//                cell.backgroundColor = UIColor(named : "Color1")
//            }
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        dateSelected.selected[indexPath.item] = false
        let selectedCell:UICollectionViewCell? = self.collectionView.cellForItem(at: indexPath)
        if selectedCell != nil {
            changeCellColor(selectedCell, didSelectItemAt: indexPath)
        }
    }
    
    func changeCellColor(_ cell: UICollectionViewCell?, didSelectItemAt indexPath: IndexPath){
        
        if dateSelected.selected[indexPath.item]{
            //            selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
            cell?.contentView.backgroundColor = UIColor(named : "Color6")
            print(indexPath.item , "selected")
        }else{
            cell?.contentView.backgroundColor = UIColor.clear
            print(indexPath.item , "deselected")
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    //    // 設置tableView每個Header的高度
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 30
    //    }
    //
    //    // 設置tableView每個Header的內容
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let view = UIView()
    //        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
    //        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
    //        viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
    //
    //        if section == 0{
    //            viewLabel.text = "班別"
    ////        }else if section == 1{
    ////            viewLabel.text = "日期別"
    //        }
    //        view.addSubview(viewLabel)
    //        tableView.addSubview(view)
    //        return view
    //    }
        
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return Global.companyShiftDateList.count
//        var count = 0
//        for i in 0 ..< Global.companyShiftDateList.count{
//
//            count += Global.companyShiftDateList[Global.shiftDateNames[i]]!.count
//        }
//        return count
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
            staffNumString += list![key]!![i].staffNum! + "  人\n"
            
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
        
        if dateSelected.getSelected() == -1 {
            dateSelected.selected[0] = true
        }
        dayType[dateSelected.getSelected()] = cell1.dateName.text!
        
        cell1.backgroundColor = UIColor (named : "Color1")
        cell1.tintColor = UIColor (named : "Color5")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deSelected" , indexPath.item)
        
        let cell1 = tableView.cellForRow(at: indexPath) as! ShiftSetTableViewCell

        cell1.backgroundColor = UIColor.clear
    }
    
    
    
}
