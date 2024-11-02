import Foundation
import SwiftUI
import Charts
import Inject

struct FinancialChartView: View {
    @ObserveInjection var inject  // Add for hot reloading
    let data: [FinancialDataPoint]
    
    private var minAmount: Double {
        data.map(\.amount).min() ?? 0
    }
    
    private var maxAmount: Double {
        data.map(\.amount).max() ?? 0
    }
    
    private var extendedData: [FinancialDataPoint] {
        guard let lastPoint = data.last else { return data }
        
        // Create a new point exactly 1 month after the last point
        let calendar = Calendar.current
        guard let extendedDate = calendar.date(
            byAdding: .day,
            value: 7,
            to: lastPoint.date
        )?.startOfDay() else { return data }
        
        let extraPoint = FinancialDataPoint(
            date: extendedDate,
            amount: lastPoint.amount
        )
        return data + [extraPoint]
    }
    
    private var yAxisPadding: Double {
        let range = maxAmount - minAmount
        return range * 0.3 // 30% padding
    }
    
    var body: some View {
        Chart {
            // Single area mark
            ForEach(extendedData) { point in
                AreaMark(
                    x: .value("Date", point.date),
                    y: .value("Amount", point.amount)
                )
                .foregroundStyle(
                    .linearGradient(
                        colors: [.white.opacity(0.3), .white.opacity(0.01)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            
            ForEach(extendedData) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Amount", point.amount)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(lineWidth: 8))
                .interpolationMethod(.monotone)
            }
            
            if let todayPoint = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                PointMark(
                    x: .value("Date", todayPoint.date),
                    y: .value("Amount", todayPoint.amount)
                )
                .foregroundStyle(.white)
                .symbolSize(300)
                .annotation(position: .top) {
                    Text("Today")
                        .foregroundColor(.white)
                        .font(.subheadline.bold())
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
            }
        }
        .chartYScale(domain: (minAmount - yAxisPadding)...(maxAmount + yAxisPadding))
        .chartXAxis {
            AxisMarks(preset: .inset, values: data.map { $0.date }) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date.formatted(.dateTime.month().day()))
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYAxis(.hidden)
        .clipped()
        .enableInjection()
    }
}

extension FinancialChartView {
    struct FinancialDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Double
    }
}

// Preview provider
struct FinancialChartView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialChartView(data: sampleData)
            .greenGradientBackground()
    }
    
    static var sampleData: [FinancialChartView.FinancialDataPoint] = [
        .init(date: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, amount: 72000),
        .init(date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!, amount: 74000),
        .init(date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, amount: 73500),
        .init(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, amount: 76000),
        .init(date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, amount: 77500),
        .init(date: Date(), amount: 78839)
    ]
}

// Add this extension to normalize the dates
extension Date {
    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
