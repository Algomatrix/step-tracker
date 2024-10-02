//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/07/25.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
