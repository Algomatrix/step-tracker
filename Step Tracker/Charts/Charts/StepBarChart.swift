//
//  StepBarChart.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/07/25.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?

    var chartData: [DateValueChartData]

    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }

    var averageSteps: Int {
        Int(chartData.map { $0.value }.average)
    }

    var body: some View {
        let config = ChartContainerConfiguration(
            title: "Steps",
            symbol: "figure.walk",
            subtitle: "Avg: \(averageSteps.formatted()) Steps",
            context: .steps,
            isNav: true
        )

        ChartContainer(config: config) {
            Chart {
                if let selectedData {
                    ChartAnnotationView(data: selectedData, context: .steps)
                }

                if !chartData.isEmpty {
                    RuleMark(y: .value("Average", averageSteps))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                }
                
                ForEach(chartData) { steps in
                    BarMark(
                        x: .value("Date", steps.date, unit: .day),
                        y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedData?.date ? 1.0 : 0.3)
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                }
            }
            .overlay {
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.bar", title: "No Data", description: "There is no step count data from Health App.")
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
}

#Preview {
    StepBarChart(chartData: [])
}
