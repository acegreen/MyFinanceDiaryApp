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
            
            // Single line mark
            ForEach(extendedData) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Amount", point.amount)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(lineWidth: 8))
                .interpolationMethod(.monotone)
            }
            
            // Dotted line for the extension
            if let lastPoint = data.last, let extraPoint = extendedData.last {
                LineMark(
                    x: .value("Date", lastPoint.date),
                    y: .value("Amount", lastPoint.amount)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(dash: [5]))
                
                LineMark(
                    x: .value("Date", extraPoint.date),
                    y: .value("Amount", extraPoint.amount)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(dash: [5]))
            }
            
            // Only last point with Today label
            if let lastPoint = data.last {
                PointMark(
                    x: .value("Date", lastPoint.date),
                    y: .value("Amount", lastPoint.amount)
                )
                .foregroundStyle(.white)
                .symbolSize(500)
                .annotation(position: .top) {
                    Text("Today")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
            }
        }
        .frame(height: 200)
        .chartYScale(domain: (minAmount - yAxisPadding)...(maxAmount + yAxisPadding))
        .chartXAxis {
            AxisMarks(preset: .automatic, values: data.map { $0.date }) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date.formatted(.dateTime.month().day()))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYAxis(.hidden)
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
            .background(Color.primaryGreen)
            .padding()
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
