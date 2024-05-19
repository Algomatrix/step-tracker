//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/05/19.
//

import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
