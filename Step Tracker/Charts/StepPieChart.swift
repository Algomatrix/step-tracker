//
//  StepPieChart.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/10/03.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    var chartData: [WeekdayChartData]
    
    @State private var rawSelectedChartValue: Double? = 0
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedChartValue else { return nil }
        var total = 0.0
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Label("Averages", systemImage: "calendar")
                        .font(.title3.bold())
                        .foregroundStyle(.pink)
                    
                    Text("Last 28 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 12)
                
                Chart {
                    ForEach(chartData) { weekday in
                        SectorMark(angle: .value("Average Steps", weekday.value),
                                   innerRadius: .ratio(0.618),
                                   outerRadius: selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 140 : 110,
                                   angularInset: 1)
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(6)
                        .opacity(selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 1.0 : 0.3)
                    }
                }
                .chartAngleSelection(value: $rawSelectedChartValue.animation(.easeInOut))
                .frame(height: 240)
                .chartBackground { proxy in
                    GeometryReader { geo in
                        if let plotFrame = proxy.plotFrame {
                            let frame = geo[plotFrame]
                            if let selectedWeekday {
                                VStack {
                                    Text(selectedWeekday.date.weekdayTitle)
                                        .font(.title3.bold())
                                        .contentTransition(.identity)
                                    
                                    Text(selectedWeekday.value, format: .number.precision(.fractionLength(0)))
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                        .contentTransition(.numericText())
                                }
                                .position(x: frame.midX, y: frame.midY)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: HealthMetric.mockData))
}
