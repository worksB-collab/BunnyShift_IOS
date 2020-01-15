//
//  DefaultViewModel.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 3/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DayViewModel: NSObject {

    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)

    lazy var events = [DefaultEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 5), location: "Ada"),
                       DefaultEvent(id: "1", title: "Two", startDate: secondDate, endDate: secondDate.add(component: .hour, value: 4), location: "Betty"),
                       DefaultEvent(id: "2", title: "Three", startDate: secondDate, endDate: thirdDate.add(component: .hour, value: 2), location: "Celia"),
                       DefaultEvent(id: "3", title: "Four", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 26), location: "Dorista")]

    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)

    var currentSelectedData: OptionsSelectedData!
}
