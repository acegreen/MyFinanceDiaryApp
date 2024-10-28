import SwiftUI
import Charts

struct HeaderView: View {
    @ObservedObject var viewModel: OverviewViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Credit Score Section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Credit score")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("791")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                Spacer()
                HStack(spacing: 16) {
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
            
            // Tab Selection
            ScrollView(.horizontal, showsIndicators: false) {
                Picker("View Selection", selection: $viewModel.selectedSegment) {
                    ForEach(OverviewViewModel.ChartSegment.allCases, id: \.self) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .colorScheme(.dark) // Force dark mode for white text
            }
            .padding(.horizontal, -20)
            .padding(.horizontal, 20)
            
            // Amount Display
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.currentAmount)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: viewModel.changeIsPositive ? "arrow.up" : "arrow.down")
                        .foregroundColor(viewModel.changeIsPositive ? .green : .red)
                    Text(viewModel.changeDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(.top, 8)
            
            // Chart
            FinancialChartView(data: viewModel.chartData)
        }
        .padding(24)
        .padding(.top, 48)
        .background(
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// Separate Net Worth Info Component
struct NetWorthInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TitleView()
            AmountView()
            ChangeView()
        }
    }
}

// Further broken down components
private struct TitleView: View {
    var body: some View {
        Text("Net Worth")
            .font(.headline)
            .foregroundColor(.white)
    }
}

private struct AmountView: View {
    var body: some View {
        Text("$78,839")
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(.white)
    }
}

private struct ChangeView: View {
    var body: some View {
        HStack {
            Text("+$200 this month")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
    }
}
