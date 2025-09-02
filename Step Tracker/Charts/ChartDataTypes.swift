//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/07/25.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
