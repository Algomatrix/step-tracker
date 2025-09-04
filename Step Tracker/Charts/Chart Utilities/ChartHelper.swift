//
//  ChartHelper.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2025/09/02.
//

import Foundation
import Algorithms

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }

    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekDayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgStep = total / Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgStep))
        }
        
        return weekDayChartData
    }

    static func averageDailyWeightDiff(for weights: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []

        guard weights.count > 1 else { return [] }
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
        }

        let sortedByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }

        var weekdayChartData: [DateValueChartData] = []
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total / Double(array.count)

            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }

        // print in console to see diff
//        for data in weekdayChartData {
//            print("\(data.date.weekdayInt), \(data.value)")
//        }

        return weekdayChartData
    }
}
