//
//  ChartContainer.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2025/09/02.
//

import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
}

struct ChartContainer<Content: View>: View {

    let chartType: ChartType
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            if isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
                        
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var navigationLinkView: some View {
        NavigationLink(value: context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
        .accessibilityHint("Tap for data in list view")
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subtitle)
                .font(.caption)
        }
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilityLable)
        .accessibilityElement(children: .ignore)
    }

    var isNav: Bool {
        switch chartType {
        case .stepBar(_), .weightLine(_):
            return true
        case .stepWeekdayPie, .weightDiffBar:
            return false
        }
    }
    
    var context: HealthMetricContext {
        switch chartType {
        case .stepBar(_), .stepWeekdayPie:
                .steps
        case .weightLine(_), .weightDiffBar:
                .weight
        }
    }
    
    var title: String {
        switch chartType {
        case .stepBar(_):
            "Steps"
        case .stepWeekdayPie:
            "Averages"
        case .weightLine(_):
            "Weight"
        case .weightDiffBar:
            "Average Weight Change"
        }
    }
    
    var symbol: String {
        switch chartType {
        case .stepBar(_):
            "figure.walk"
        case .stepWeekdayPie:
            "calendar"
        case .weightLine(_), .weightDiffBar:
            "figure"
        }
    }
    
    var subtitle: String {
        switch chartType {
        case .stepBar(let average):
            "Avg: \(average.formatted()) steps"
        case .stepWeekdayPie:
            "Last 28 Days"
        case .weightLine(let average):
            "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
        case .weightDiffBar:
            "Per Weekday (Last 7 Days)"
        }
    }
        
    var accessibilityLable: String {
        switch chartType {
        case .stepBar(let average):
            "Bar Chart, Step Count, Last 28 Days, Average steps per day \(average) steps"
        case .stepWeekdayPie:
            "Pie chart, Last 28 Days"
        case .weightLine(let average):
            "Line Chart, Weight, Average weight: \(average.formatted(.number.precision(.fractionLength(1)))) Kilos, Goal weight: 70 Kilos"
        case .weightDiffBar:
            "Bar Chart, Average weight difference per weekday"
        }
    }
}

#Preview {
    ChartContainer(chartType: .stepWeekdayPie, content: {
        Text("Chart goes here")
            .frame(height: 150)
    })
}
