//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/07/25.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
