//
//  codeScheduleViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/5.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit
import FSCalendar

class codeScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    //singleton
    static let sharedInstance = codeScheduleViewController()
    
    fileprivate weak var calendar: FSCalendar!
    
    var names = ["Anders", "Kristian", "Sofia", "John", "Jenny", "Lina", "Annie", "Katie", "Johanna"]
    var shifts = ["morning", "evening" , "midnight"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shiftCollectionView: UICollectionView!
    
    var byScope = true
    
    @IBAction func btn_save(_ sender: UIBarButtonItem) {
        // save all the points in calendar
    }
    
    
    //month or week filter
    @IBOutlet weak var scope_btn: UIButton!
    @IBAction func scope_btn(_ sender: UIButton) {
        if byScope{
            byScope = false
            calendar.scope = .week
            scope_btn.setTitle("by week", for: .normal)
        }else{
            byScope = true
            calendar.scope = .month
            scope_btn.setTitle("by month", for: .normal)
        }
    }
    //month or week filter ends
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib() // collection view settings
        setCalendar() // calendar settings
        setNav()
        loadData()
        
        
        
    }
    
    func loadData(){
        var str : String = ""
        let preferencesRead = UserDefaults.standard
        if preferencesRead.object(forKey: "name") == nil {
                //  Doesn't exist
                NSLog("NO name", "...")
        } else {
            let account = preferencesRead.string(forKey: "account")
            
            let password = preferencesRead.string(forKey: "password")
            str = "account: " + account! + "password: " + password!
        }

        print("wow  " + str)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setNav(){
        navigationItem.title = "排班表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        

    }
    
    func setCalendar(){
        let calendar = FSCalendar(frame: CGRect(x: 5, y: 250, width: view.frame.width-10, height: view.frame.height-400))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        view.addSubview(calendar)
        calendar.allowsMultipleSelection = true;
        self.calendar = calendar
    }
    
    // for collection view registration
    func registerNib() {
        //member collectionView
        let nib1 = UINib(nibName: CompanyScheduleCollectionViewCell.nibName, bundle: nil)
        collectionView?.register(nib1, forCellWithReuseIdentifier: CompanyScheduleCollectionViewCell.reuseIdentifier)
        if let flowLayout1 = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 1, height: 1)
            
        }
        
        //shift collectionView
        let nib2 = UINib(nibName: CompanyScheduleCollectionViewCell.nibName, bundle: nil)
        shiftCollectionView?.register(nib2, forCellWithReuseIdentifier: CompanyScheduleCollectionViewCell.reuseIdentifier)
        if let flowLayout2 = self.shiftCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout2.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        	
        
    }
    // collection views
    //member collectionView start
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            
            return names.count
        }else{
            return shifts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyScheduleCollectionViewCell.reuseIdentifier,for: indexPath) as? CompanyScheduleCollectionViewCell {
                let name = names[indexPath.row]
                cell.configureCell(name: name)
                return cell
            }
            return UICollectionViewCell()
        }else{
            if let cell = shiftCollectionView.dequeueReusableCell(withReuseIdentifier: CompanyScheduleCollectionViewCell.reuseIdentifier,for: indexPath) as? CompanyScheduleCollectionViewCell {
                let name = shifts[indexPath.row]
                cell.configureCell(name: name)
                return cell
            }
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CompanyScheduleCollectionViewCell = Bundle.main.loadNibNamed(CompanyScheduleCollectionViewCell.nibName, owner: self, options: nil)?.first as? CompanyScheduleCollectionViewCell else {
            return CGSize.zero
        }
        // check which data should the current CollectionView should take
        if collectionView == self.collectionView{
            cell.configureCell(name: names[indexPath.row])
        }else{
            
            cell.configureCell(name: shifts[indexPath.row])
        }
        
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: 60, height: 30)
    }
    
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
        print("ffff")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cellToDeselect:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
    cellToDeselect.contentView.backgroundColor = UIColor.clear
    }
    
    
    // collection views end
}












extension codeScheduleViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    
    //    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
    //        return UIImage( named :"pic02")
    //    }
    //    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    //        let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
    
    ////        cell.imageView.contentMode = .scaleAspectFit
    
    //        return cell
    
    //    }
    //    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    //        return "maxcodes.io"
    //    }
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //        return "subscribe"
    //    }
    
    
}




    

