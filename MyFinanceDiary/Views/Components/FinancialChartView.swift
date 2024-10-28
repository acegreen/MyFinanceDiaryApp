import SwiftUI
import Charts
import Inject

// Rename to FinancialChartView to be more generic
struct FinancialChartView: View {
    let data: [FinancialDataPoint]
    
    private var minAmount: Double {
        guard let min = data.map({ $0.amount }).min() else { return 0 }
        return min * 0.95 // Give 5% padding below minimum
    }
    
    private var maxAmount: Double {
        guard let max = data.map({ $0.amount }).max() else { return 0 }
        return max * 1.05 // Give 5% padding above maximum
    }
    
    var body: some View {
        Chart {
            ForEach(data) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Amount", point.amount)
                )
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(.white)
            
            ForEach(data) { point in
                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Amount", point.amount)
                )
                .foregroundStyle(.white)
            }
        }
        .frame(height: 200)
        .padding(.horizontal)
        .chartYScale(domain: minAmount...maxAmount) // Set y-axis scale with padding
        .chartXAxis {
            AxisMarks(preset: .aligned, values: data.map { $0.date }) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date.formatted(.dateTime.month().day()))
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                }
            }
        }
        .chartYAxis(.hidden)
    }
}

// Rename to be more generic
struct FinancialDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

// Preview provider
struct FinancialChartView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialChartView(data: sampleData)
            .background(Color.green)
            .padding()
    }
    
    static var sampleData: [FinancialDataPoint] = [
        FinancialDataPoint(date: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, amount: 72000),
        FinancialDataPoint(date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!, amount: 74000),
        FinancialDataPoint(date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, amount: 73500),
        FinancialDataPoint(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, amount: 76000),
        FinancialDataPoint(date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, amount: 77500),
        FinancialDataPoint(date: Date(), amount: 78839)
    ]
}
