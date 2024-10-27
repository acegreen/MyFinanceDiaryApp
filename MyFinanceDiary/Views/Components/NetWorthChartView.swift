import SwiftUI
import Charts
import Inject

struct NetWorthChartView: View {
    @ObserveInjection var inject
    
    let data: [NetWorthDataPoint]
    
    private var minValue: Double {
        data.map(\.value).min() ?? 0
    }
    
    private var maxValue: Double {
        data.map(\.value).max() ?? 0
    }
    
    var body: some View {
        Chart(data) { dataPoint in
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Value", dataPoint.value)
            )
            .foregroundStyle(.white.opacity(0.8))

            PointMark(
                x: .value("Date", data.last!.date),
                y: .value("Value", data.last!.value)
            )
            .foregroundStyle(.white)
        }
        .frame(height: 200)
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisValueLabel()
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(domain: minValue * 0.95...maxValue * 1.05)
        .enableInjection()
    }
}

// For testing purposes
extension NetWorthChartView {
    static var sampleData: [NetWorthDataPoint] = [
        NetWorthDataPoint(date: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, value: 72000),
        NetWorthDataPoint(date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!, value: 74000),
        NetWorthDataPoint(date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, value: 73500),
        NetWorthDataPoint(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, value: 76000),
        NetWorthDataPoint(date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, value: 77500),
        NetWorthDataPoint(date: Date(), value: 78839)
    ]
}

// Preview provider
struct NetWorthChartView_Previews: PreviewProvider {
    static var previews: some View {
        NetWorthChartView(data: NetWorthChartView.sampleData)
            .frame(height: 100)
            .background(Color.green)
            .padding()
    }
}

// Move this to a separate Models file if not already there
struct NetWorthDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
