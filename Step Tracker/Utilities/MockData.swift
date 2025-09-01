//
//  MockData.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2025/08/31.
//

import Foundation

struct MockData {
    static var steps: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!, value: .random(in: 4_000...15_000))
            
            array.append(metric)
        }
        
        return array
    }
    
    static var weights: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!, value: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            
            array.append(metric)
        }
        
        return array
    }

    static var weightDiff: [WeekdayChartData] {
        var array: [WeekdayChartData] = []

        for i in 0..<7 {
            let diff = WeekdayChartData(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                          value: .random(in: -3...3))

            array.append(diff)
        }

        return array
    }
}
