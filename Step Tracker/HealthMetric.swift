//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Sean Allen on 4/23/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
