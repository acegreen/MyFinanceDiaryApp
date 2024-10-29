import Foundation
import SwiftUI

class CreditScoreViewModel: ObservableObject {
    @Published var creditScore: Int
    @Published var lastUpdated: String = ""
    @Published var scoreChange: Int = 0
    @Published var metrics: [CreditMetric] = []
    
    init(initialScore: Int) {
        self.creditScore = initialScore
        fetchCreditScore()
    }
    
    func fetchCreditScore() {
        lastUpdated = "7/20/20"
        scoreChange = 8
        
        metrics = [
            CreditMetric(
                title: "On-time payments",
                value: "95%",
                status: "Good",
                statusColor: .green,
                detail: "1 missed"
            ),
            CreditMetric(
                title: "Credit utilization",
                value: "45%",
                status: "Not bad",
                statusColor: .orange,
                detail: "▼ 15%"
            ),
            CreditMetric(
                title: "Age of credit",
                value: "8 yrs",
                status: "Good",
                statusColor: .green,
                detail: nil
            )
        ]
    }
}

struct CreditMetric {
    let title: String
    let value: String
    let status: String
    let statusColor: Color
    let detail: String?
} 
