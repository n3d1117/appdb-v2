//
//  AppDetailDownloadsView.swift
//  
//
//  Created by ned on 12/02/23.
//

import SwiftUI
import Charts

public struct AppDetailDownloadsView: View {
    private struct Entry: Identifiable {
        let id = UUID()
        let period: String
        let amount: Int
    }
    private let data: [Entry]
    
    @ScaledMetric private var spacing: CGFloat = 8
    
    public init(clicksToday: Int, clicksWeek: Int, clicksMonth: Int, clicksYear: Int, clicksTotal: Int) {
        self.data = [
            .init(period: "Today", amount: clicksToday),
            .init(period: "This Week", amount: clicksWeek),
            .init(period: "This Month", amount: clicksMonth),
            .init(period: "This Year", amount: clicksYear),
            .init(period: "All Time", amount: clicksTotal),
        ]
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text("Downloads")
                .font(.title3)
                .fontWeight(.semibold)
            
            Chart(data) { item in
                BarMark(
                    x: .value("", item.amount),
                    y: .value("", item.period),
                    width: .fixed(8)
                )
                .annotation(position: .trailing) {
                    Text(item.amount.formatted())
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
                .foregroundStyle(.tint)
            }
            .chartYAxis {
                AxisMarks(preset: .extended) { value in
                    AxisValueLabel(horizontalSpacing: 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

struct AppDetailDownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailDownloadsView(clicksToday: 5, clicksWeek: 50, clicksMonth: 100, clicksYear: 150, clicksTotal: 200)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
