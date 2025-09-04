//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/05/14.
//

import SwiftUI

struct HealthDataListView: View {

    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var isShowingAlert = false
    @State private var writeError: STError = .noData
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""

    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }

    var body: some View {
        List(listData.reversed()) { data in
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            } label: {
                Text(data.date, format: .dateTime.month().day().year())
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }

    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                LabeledContent(metric.title) {
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .alert(isPresented: $isShowingAlert, error: writeError) { writeError in
                // Buttons
                switch writeError {
                case .authNotDetermined, .noData, .unableToCompleteRequest, .invalidValue:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            } message: { writeError in
                Text(writeError.failureReason)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        addDataToHealthKit()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }

    private func addDataToHealthKit() {
        guard let value = Double(valueToAdd) else {
            writeError = .invalidValue
            isShowingAlert = true
            valueToAdd = ""
            return
        }
        Task {
            do {
                if metric == .steps {
                    try await hkManager.addStepData(for: addDataDate, value: value)
                    hkManager.stepData = try await hkManager.fetchStepCount()
                } else {
                    try await hkManager.addWeightData(for: addDataDate, value: value)
                    async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                    async let weightsForDiffBarChart = hkManager.fetchWeights(daysBack: 29)
                    
                    hkManager.weightData = try await weightsForLineChart
                    hkManager.weightDiffData = try await weightsForDiffBarChart
                }

                isShowingAddData = false
            } catch STError.sharingDenied(let quantityType) {
                writeError = .sharingDenied(quantityType: quantityType)
                isShowingAlert = true
            } catch {
                writeError = .unableToCompleteRequest
                isShowingAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .weight)
            .environment(HealthKitManager())
    }
}
