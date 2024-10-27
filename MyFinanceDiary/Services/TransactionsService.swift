import Foundation

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [Transaction]
}

class TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [Transaction] {
        // TODO: Replace with actual API call
        // Temporary mock data
        return (0..<100).map { index in
            let daysAgo = Double(index / 3) * 86400 // Divide by 3 to have multiple transactions per day
            let isCredit = index % 5 == 0 // Every 5th transaction is a credit
            
            let descriptions = [
                "Grocery Shopping", "Restaurant", "Gas Station", "Online Shopping",
                "Coffee Shop", "Pharmacy", "Movie Theater", "Gym Membership",
                "Utilities", "Phone Bill", "Internet Bill", "Public Transport",
                "Clothing Store", "Electronics", "Home Improvement"
            ]
            
            let amounts = isCredit ? 
                [2500.00, 3000.00, 3500.00, 4000.00, 4500.00] :
                [15.75, 25.50, 45.99, 85.50, 125.00, 200.00, 350.00]
            
            return Transaction(
                date: Date().addingTimeInterval(-daysAgo),
                transactionDescription: descriptions.randomElement() ?? "Transaction",
                amount: amounts.randomElement() ?? 50.00,
                type: isCredit ? .credit : .debit
            )
        }
    }
}
