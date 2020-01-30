//
//  DefaultViewController.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 3/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultViewController: UIViewController {

    //因為isEnable = false所以不會有效果
    @IBAction func btn_take_leave(_ sender: UIBarButtonItem) {
        Toast.showToast(self.view, "今天沒有班喔")
    }
    
    @IBOutlet weak var calendarWeekView: DefaultWeekView!

    // billy added
    var timer: Timer?
    var presentingDate : Date?
    var presentingDateID : Int?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    //
    let viewModel = DefaultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.assignToEachDay()
        setupBasic()
        setCalendarView()
        setNav()
        presentingDate = viewModel.currentSelectedData.date
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopTimer), userInfo: nil, repeats: true)
    }
    
    var countStop = 0
    @objc func stopTimer() {
        viewModel.assignToEachDay()
        countStop += 1
        if countStop == 3{
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
    }
    
    func setNav(){
        navigationItem.title = "當日班表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color7")! ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        if currentShift().count == 0{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func currentShift() -> Array<String>{

        var arrShift = Array<String>()
        let date = dateFormatter.string(from : presentingDate!)
        
        for i in Global.monthlyShiftArr!{
            if i?.staffName == Global.staffInfo?.name, i?.date == date{
                arrShift.append(i!.timeName)
            }
        }
//        // get dateID
//        let api1 = "/search/calendar/" + year + "/" + month
//        NetWorkController.sharedInstance.get(api: api1){(jsonData) in
//            if jsonData["Status"].string == "200"{
//                let arr = jsonData["rows"]
//                for i in 0 ..< arr.count{
//                    let companyJson = arr[i]
//                    if companyJson["date"].string == date{
//                        self.presentingDateID = companyJson["dateID"].int
//
//                        var a = ""
//                        if let abs = Global.companyInfo!.ltdID{
//                            if let id = self.presentingDateID{
//                                a += "/search/schedulebydate/" + "\(id)" + "/\(abs)"
//                            }
//                        }
//
//                        NetWorkController.sharedInstance.get(api: a){(jsonData) in
//                            if jsonData["Status"].string == "200"{
//                                let arr = jsonData["rows"]
//                                for i in 0 ..< arr.count{
//                                    let companyJson = arr[i]
//                                    if companyJson["staffName"].string == Global.staffInfo?.name{
//                                        let shift = companyJson["timeShiftName"].string
//                                        arrShift.append(shift!)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        return arrShift
    }

    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }

    private func setCalendarView() {
        calendarWeekView.baseDelegate = self
        
        
        //billy added
        var date1 = dateFormatter.date(from: TakeLeaveController.selectedDate!)
                
        let numOfDays = 1
        let firstDayOfWeek = numOfDays == 7 ? calendarWeekView.firstDayOfWeek : nil
        
        var optionsSD = OptionsSelectedData(viewType: .defaultView,
                                            date: date1!,
        numOfDays: numOfDays,
        scrollType: .pageScroll,
        firstDayOfWeek: firstDayOfWeek,
        hourGridDivision: .minutes_15, scrollableRange: (nil, nil))

        viewModel.currentSelectedData = optionsSD
        //
        
        
        
        // For example only
        if viewModel.currentSelectedData != nil {
            setCalendarViewWithSelectedData()
            return
        }
        // Basic setup
        calendarWeekView.setupCalendar(numOfDays: 1,
                                       setDate: Date(),
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: .pageScroll)
        // Optional
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: JZHourGridDivision.noneDiv))
    }

    /// For example only
    private func setCalendarViewWithSelectedData() {
        guard let selectedData = viewModel.currentSelectedData else { return }
        calendarWeekView.setupCalendar(numOfDays: selectedData.numOfDays,
                                       setDate: selectedData.date,
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: selectedData.scrollType,
                                       firstDayOfWeek: selectedData.firstDayOfWeek)
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
    }
}

extension DefaultViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNaviBarTitle()
    }
}

// For example only
extension DefaultViewController: OptionsViewDelegate {

    func setupBasic() {
        // Add this to fix lower than iOS11 problems
        self.automaticallyAdjustsScrollViewInsets = false
    }

    

    @objc func presentOptionsVC() {
        guard let optionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as? ExampleOptionsViewController else {
            return
        }
        let optionsViewModel = OptionsViewModel(selectedData: getSelectedData())
        optionsVC.viewModel = optionsViewModel
        optionsVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: optionsVC)
        self.present(navigationVC, animated: true, completion: nil)
    }

    private func getSelectedData() -> OptionsSelectedData {
        
        let numOfDays = calendarWeekView.numOfDays!
        let firstDayOfWeek = numOfDays == 7 ? calendarWeekView.firstDayOfWeek : nil
        viewModel.currentSelectedData = OptionsSelectedData(viewType: .defaultView,
                                                            date: calendarWeekView.initDate.add(component: .day, value: numOfDays),
                                                            numOfDays: numOfDays,
                                                            scrollType: calendarWeekView.scrollType,
                                                            firstDayOfWeek: firstDayOfWeek,
                                                            hourGridDivision: calendarWeekView.flowLayout.hourGridDivision,
                                                            scrollableRange: calendarWeekView.scrollableRange)
        return viewModel.currentSelectedData
    }

    func finishUpdate(selectedData: OptionsSelectedData) {
        
        
        // Update numOfDays
        if selectedData.numOfDays != viewModel.currentSelectedData.numOfDays {
            calendarWeekView.numOfDays = selectedData.numOfDays
            calendarWeekView.refreshWeekView()
        }
        // Update Date
        if selectedData.date != viewModel.currentSelectedData.date {
            calendarWeekView.updateWeekView(to: selectedData.date)
        }
        // Update Scroll Type
        if selectedData.scrollType != viewModel.currentSelectedData.scrollType {
            calendarWeekView.scrollType = selectedData.scrollType
            // If you want to change the scrollType without forceReload, you should call setHorizontalEdgesOffsetX
            calendarWeekView.setHorizontalEdgesOffsetX()
        }
        // Update FirstDayOfWeek
        if selectedData.firstDayOfWeek != viewModel.currentSelectedData.firstDayOfWeek {
            calendarWeekView.updateFirstDayOfWeek(setDate: selectedData.date, firstDayOfWeek: selectedData.firstDayOfWeek)
        }
        // Update hourGridDivision
        if selectedData.hourGridDivision != viewModel.currentSelectedData.hourGridDivision {
            calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
        }
        // Update scrollableRange
        if selectedData.scrollableRange != viewModel.currentSelectedData.scrollableRange {
            calendarWeekView.scrollableRange = selectedData.scrollableRange
        }
    }

    private func updateNaviBarTitle() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM"
        self.navigationItem.title = dateFormatter.string(from: calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays))
        
        presentingDate = calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays)
        setNav()
        navigationController?.navigationBar.reloadInputViews()
    }
}
