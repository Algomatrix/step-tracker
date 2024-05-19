//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/05/12.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
