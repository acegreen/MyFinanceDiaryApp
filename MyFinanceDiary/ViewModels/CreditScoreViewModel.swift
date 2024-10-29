import Foundation
import SwiftUI

class CreditScoreViewModel: ObservableObject {
    @Published var creditScore: Int
    @Published var lastUpdated: String = ""
    @Published var scoreChange: Int = 0
    @Published var metrics: [CreditMetric] = []
    
    init(initialScore: Int = 0) {
        self.creditScore = initialScore
        fetchCreditScore()
    }
    
    func fetchCreditScore() {
        creditScore = 821
        lastUpdated = "7/20/24"
        scoreChange = 10
        
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

extension CreditScoreViewModel {
    struct CreditMetric {
        let title: String
        let value: String
        let status: String
        let statusColor: Color
        let detail: String?
    }
}
