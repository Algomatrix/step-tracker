//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/07/20.
//vf

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
