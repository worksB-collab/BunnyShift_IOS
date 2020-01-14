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

class ScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        staffSelected = ItemSelection(names)
        super.init(coder: aDecoder)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
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
        navigationBarSettings()
        
        
    }
    
    // for collection view registration
    
    func navigationBarSettings(){
        navigationItem.title = "班表總覽"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true

    }
    
    func calendarSettings(){
        let calendar = FSCalendar(frame: CGRect(x: 5, y: 150, width: view.frame.width-10, height: view.frame.height-300))
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
    
    func jumpToSchedule(){
//            if let controller = storyboard?.instantiateViewController(withIdentifier: "") {
//                present(controller, animated: true, completion: nil)
//        }
    }
    
    
    // collection view
    var names = ["Anders", "Kristian", "Sofia", "John", "Jenny", "Lina", "Annie", "Katie", "Johanna"]
    var staffSelected : ItemSelection
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func registerNib() {
        
        // register cell
        collectionView.register(UINib(nibName: StaffCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: StaffCollectionViewCell.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
            return names.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,for: indexPath) as? StaffCollectionViewCell {
                let name = names[indexPath.row]
                cell.configureCell(name: name)
                cell.clipsToBounds = true
                cell.layer.cornerRadius = cell.frame.height/2
                changeCellColor(cell, didSelectItemAt: indexPath)
                return cell
            }
            return UICollectionViewCell()
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        staffSelected.selected[indexPath.item] = true
        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        changeCellColor(selectedCell, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        staffSelected.selected[indexPath.item] = false
        let selectedCell:UICollectionViewCell? = self.collectionView.cellForItem(at: indexPath)
        if selectedCell != nil {
        changeCellColor(selectedCell, didSelectItemAt: indexPath)
        }
    }
    
    func changeCellColor(_ cell: UICollectionViewCell?, didSelectItemAt indexPath: IndexPath){
        
        if staffSelected.selected[indexPath.item]{
//            selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
            cell?.contentView.backgroundColor = UIColor(named : "Color6")
            print(indexPath.item , "selected")
        }else{
            cell?.contentView.backgroundColor = UIColor.clear
            print(indexPath.item , "deselected")
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
