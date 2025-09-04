//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/05/12.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
case steps, weight
    var id: Self { self }
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
            
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {

    @Environment(HealthKitManager.self) private var hkManager
    @Environment(HealthKitData.self) private var hkData
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var isShowingAlert = false
    @State private var fetchError: STError = .noData

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(chartData: ChartHelper.convert(data: hkData.stepData))
                        StepPieChart(chartData: ChartHelper.averageWeekdayCount(for: hkData.stepData))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkData.weightData))
                        WeightDiffBarChart(chartData: ChartHelper.averageDailyWeightDiff(for: hkData.weightDiffData))
                    }
                }
            }
            .padding()
            .task { fetchHealthData() }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                fetchHealthData()
            }, content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                // Action Buttons
            } message: { fetchError in
                Text(fetchError.failureReason)
            }
        }
        .tint(selectedStat == .steps ? .pink : .indigo)
    }
    
    private func fetchHealthData() {
        Task {
            do {
//                try await hkManager.addSimulatorData()
                async let steps = hkManager.fetchStepCount()
                async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                async let weightsForDiffBarChart = hkManager.fetchWeights(daysBack: 29)
                
                hkData.stepData = try await steps
                hkData.weightData = try await weightsForLineChart
                hkData.weightDiffData = try await weightsForDiffBarChart

            } catch STError.authNotDetermined {
                isShowingPermissionPrimingSheet = true
            } catch STError.noData {
                fetchError = .noData
                isShowingAlert = true
            } catch {
                fetchError = .unableToCompleteRequest
                isShowingAlert = true
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
