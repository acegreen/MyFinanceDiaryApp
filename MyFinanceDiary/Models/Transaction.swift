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
    var categories: [TransactionCategory]?
    var personalFinanceCategory: PersonalFinanceCategory?
    @Attribute var logoUrl: String?
    @Attribute var categoryIconUrl: String?
    var accountId: String?
    var location: Location?
    var paymentChannel: String?
    var paymentMeta: PaymentMeta?
    var counterparties: [Counterparty]?

    var displayName: String {
        merchantName ?? name
    }

    var displayIconUrl: String? {
        logoUrl ?? categoryIconUrl
    }

    init(amount: Double, date: Date, name: String, merchantName: String? = nil, pending: Bool, transactionId: String, logoUrl: String? = nil, categoryIconUrl: String? = nil) {
        self.amount = amount
        self.date = date
        self.name = name
        self.merchantName = merchantName
        self.pending = pending
        self.transactionId = transactionId
        self.logoUrl = logoUrl
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
        case personalFinanceCategory = "personal_finance_category"
        case logoUrl = "logo_url"
        case categoryIconUrl = "personal_finance_category_icon_url"
        case location
        case paymentMeta = "payment_meta"
        case counterparties
    }

    // Helper to map category to account type
    var accountType: Account.AccountType {
        return .depository
    }

    // Add this required initializer for Decodable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(Double.self, forKey: .amount)
        let dateString = try container.decode(String.self, forKey: .date)
        if let parsedDate = DateFormatter.plaidDate.date(from: dateString) {
            date = parsedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match expected format")
        }
        name = try container.decode(String.self, forKey: .name)
        merchantName = try container.decodeIfPresent(String.self, forKey: .merchantName)
        pending = try container.decode(Bool.self, forKey: .pending)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        categories = try container.decodeIfPresent([TransactionCategory].self, forKey: .category)
        personalFinanceCategory = try container.decodeIfPresent(PersonalFinanceCategory.self, forKey: .personalFinanceCategory)
        logoUrl = try container.decodeIfPresent(String.self, forKey: .logoUrl)
        categoryIconUrl = try container.decodeIfPresent(String.self, forKey: .categoryIconUrl)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        paymentMeta = try container.decodeIfPresent(PaymentMeta.self, forKey: .paymentMeta)
        counterparties = try container.decodeIfPresent([Counterparty].self, forKey: .counterparties)
    }
    
    // Add encode method for Encodable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(amount, forKey: .amount)
        try container.encode(DateFormatter.plaidDate.string(from: date), forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(merchantName, forKey: .merchantName)
        try container.encode(pending, forKey: .pending)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(categories, forKey: .category)
        try container.encodeIfPresent(personalFinanceCategory, forKey: .personalFinanceCategory)
        try container.encodeIfPresent(logoUrl, forKey: .logoUrl)
        try container.encodeIfPresent(categoryIconUrl, forKey: .categoryIconUrl)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(paymentMeta, forKey: .paymentMeta)
        try container.encodeIfPresent(counterparties, forKey: .counterparties)
    }
}

extension Transaction {
    enum TransactionCategory: String, Codable, CaseIterable, Identifiable {
        case foodAndDrink = "Food and Drink"
        case restaurants = "Restaurants"
        case transfer = "Transfer"
        case payment = "Payment"
        case shopping = "Shopping"
        case recreation = "Recreation"
        case travel = "Travel"
        case healthcare = "Healthcare"
        case service = "Service"
        case tax = "Tax"
        case general = "General"
        case transportation = "Transportation"
        case rent = "Rent"
        case utilities = "Utilities"
        case entertainment = "Entertainment"
        case other = "Other"
        
        var id: String { rawValue }
        
        // Add an initializer to handle unknown categories
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            
            // Try to create from exact match first
            if let category = TransactionCategory(rawValue: rawValue) {
                self = category
            } else {
                // If no exact match, default to "other"
                self = .other
            }
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

    struct Counterparty: Codable {
        var confidenceLevel: String
        var entityId: String?
        var logoUrl: String?
        var name: String
        var phoneNumber: String?
        var type: String
        var website: String?
        
        enum CodingKeys: String, CodingKey {
            case confidenceLevel = "confidence_level"
            case entityId = "entity_id"
            case logoUrl = "logo_url"
            case name
            case phoneNumber = "phone_number"
            case type
            case website
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

