import Foundation
import SwiftData

@Model
final class Transaction: Codable {
    var amount: Double
    var date: Date
    var name: String
    var merchantName: String?
    var pending: Bool
    var transactionId: String
    var category: TransactionCategory?
    @Attribute var categoryIconUrl: String?
    var accountId: String?
    var location: Location?
    var paymentChannel: String?
    var paymentMeta: PaymentMeta?

    var displayName: String {
        merchantName ?? name
    }

    var transactionType: TransactionType {
        TransactionType(amount: amount)
    }

    init(amount: Double, date: Date, name: String, merchantName: String? = nil, pending: Bool, transactionId: String, categoryIconUrl: String? = nil) {
        self.amount = amount
        self.date = date
        self.name = name
        self.merchantName = merchantName
        self.pending = pending
        self.transactionId = transactionId
        self.categoryIconUrl = categoryIconUrl
    }

    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case amount
        case date
        case name
        case merchantName = "merchant_name"
        case pending
        case transactionId = "transaction_id"
        case category
        case categoryIconUrl = "personal_finance_category_icon_url"
        case personalFinanceCategory = "personal_finance_category"
        case location
        case paymentMeta = "payment_meta"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Double.self, forKey: .amount)

        // Convert string date to Date object
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = dateFormatter.date(from: dateString) {
            date = parsedDate
        } else {
            date = Date()
        }

        name = try container.decode(String.self, forKey: .name)
        merchantName = try container.decodeIfPresent(String.self, forKey: .merchantName)
        pending = try container.decode(Bool.self, forKey: .pending)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        categoryIconUrl = try container.decodeIfPresent(String.self, forKey: .categoryIconUrl)

        let categories = try container.decodeIfPresent([String].self, forKey: .category) ?? []
        let personalFinanceCategory = try container.decodeIfPresent(PersonalFinanceCategory.self, forKey: .personalFinanceCategory)

        self.category = TransactionCategory.from(
            plaidCategories: categories,
            personalFinanceCategory: personalFinanceCategory
        )

        self.location = try container.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        self.paymentMeta = try container.decodeIfPresent(PaymentMeta.self, forKey: .paymentMeta)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)

        // Convert Date back to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)

        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(merchantName, forKey: .merchantName)
        try container.encode(pending, forKey: .pending)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(categoryIconUrl, forKey: .categoryIconUrl)
        try container.encodeIfPresent(paymentMeta, forKey: .paymentMeta)
    }

    // Helper to map category to account type
    var accountType: Account.AccountType {
        switch self.category {
        case .creditCard:
            return .credit
        case .loan:
            return .loan
        case .investment:
            return .investment
        case .cash, .transfer:
            // For transfers, we should look at the destination
            // If it's a transfer to an investment account, it should be .investments
            // If it's a transfer to a loan/credit card, it should be .loans/.creditCards
            return .depository  // Maybe this default needs to change
        case .payment:
            // Similar to transfers, payments might need more context
            // A credit card payment should probably be .creditCards
            return .credit  // Changed from .cash
        case .other, .none:
            return .other
        }
    }
}

extension Transaction {
    enum TransactionType: String, Codable {
        case credit
        case debit

        init(amount: Double) {
            self = amount >= 0 ? .credit : .debit
        }
    }
    enum TransactionCategory: String, Codable, CaseIterable {
        case cash = "Cash"
        case creditCard = "Credit Card"
        case loan = "Loan"
        case investment = "Investment"
        case payment = "Payment"
        case transfer = "Transfer"
        case other = "Other"

        // Helper to convert from Plaid's category array
        static func from(plaidCategories: [String], personalFinanceCategory: PersonalFinanceCategory?) -> TransactionCategory {
            // First try to categorize based on personal finance category
            if let primary = personalFinanceCategory?.primary.lowercased() {
                switch primary {
                case "credit":
                    return .creditCard
                case "loan", "mortgage":
                    return .loan
                case "investment":
                    return .investment
                case "transfer":
                    return .transfer
                case "payment":
                    return .payment
                default:
                    break
                }
            }

            // Fall back to traditional categories if needed
            let allCategories = plaidCategories.map { $0.lowercased() }

            if allCategories.contains(where: { $0.contains("credit card") ||
                $0.contains("credit") ||
                $0.contains("payment") }) {
                return .creditCard
            }

            if allCategories.contains(where: { $0.contains("investment") ||
                $0.contains("stock") ||
                $0.contains("securities") }) {
                return .investment
            }

            if allCategories.contains(where: { $0.contains("loan") ||
                $0.contains("mortgage") }) {
                return .loan
            }

            if allCategories.contains(where: { $0.contains("transfer") }) {
                return .transfer
            }

            return .other
        }
    }

    struct PersonalFinanceCategory: Codable {
        let primary: String
        let detailed: String
        let confidence_level: String
    }

    struct Location: Codable {
        var address: String?
        var city: String?
        var country: String?
        var lat: Double?
        var lon: Double?
        var postalCode: String?
        var region: String?
        var storeNumber: String?
        
        enum CodingKeys: String, CodingKey {
            case address
            case city
            case country
            case lat
            case lon
            case postalCode = "postal_code"
            case region
            case storeNumber = "store_number"
        }
    }

    struct PaymentMeta: Codable {
        var byOrderOf: String?
        var payee: String?
        var payer: String?
        var paymentMethod: String?
        var paymentProcessor: String?
        var ppdId: String?
        var reason: String?
        var referenceNumber: String?
        
        enum CodingKeys: String, CodingKey {
            case byOrderOf = "by_order_of"
            case payee
            case payer
            case paymentMethod = "payment_method"
            case paymentProcessor = "payment_processor"
            case ppdId = "ppd_id"
            case reason
            case referenceNumber = "reference_number"
        }
    }
}

extension Transaction.Location {
    var coordinates: (latitude: Double, longitude: Double)? {
        #if DEBUG
        // Always return mock coordinates in debug
        return (45.5017, -73.5673)
        #else
        guard let lat = lat, let lon = lon else { return nil }
        return (lat, lon)
        #endif
    }
}
