import Foundation
import SwiftData

@Model
final class Transaction: Codable {
    // Required properties
    var accountId: String
    var amount: Double
    var category: [TransactionCategory]
    var date: Date
    var isoCurrencyCode: String
    var name: String
    var paymentChannel: PaymentChannel
    var pending: Bool
    @Attribute(.unique) var transactionId: String
    var transactionType: TransactionType
    @Relationship(inverse: \Provider.transactions) var provider: Provider?

    // Optional properties
    var accountOwner: String?
    var authorizedDate: Date?
    var authorizedDatetime: Date?
    var categoryId: String?
    var checkNumber: String?
    var counterparties: [Counterparty]?
    var datetime: Date?
    var location: Location?
    var logoUrl: String?
    var merchantEntityId: String?
    var merchantName: String?
    var paymentMeta: PaymentMeta?
    var pendingTransactionId: String?
    var personalFinanceCategory: PersonalFinanceCategory?
    var personalFinanceCategoryIconUrl: String?
    var transactionCode: String?
    var unofficialCurrencyCode: String?
    var website: String?

    var displayName: String {
        merchantName ?? name
    }

    var displayIconUrl: String? {
        logoUrl ?? personalFinanceCategoryIconUrl
    }

    // Required initializer for @Model
    init(accountId: String,
         amount: Double,
         category: [TransactionCategory],
         date: Date,
         isoCurrencyCode: String,
         name: String,
         paymentChannel: PaymentChannel,
         pending: Bool,
         transactionId: String,
         transactionType: TransactionType) {
        self.accountId = accountId
        self.amount = amount
        self.category = category
        self.date = date
        self.isoCurrencyCode = isoCurrencyCode
        self.name = name
        self.paymentChannel = paymentChannel
        self.pending = pending
        self.transactionId = transactionId
        self.transactionType = transactionType
    }

    private enum CodingKeys: String, CodingKey {
        case accountId
        case amount
        case category
        case date
        case isoCurrencyCode
        case name
        case paymentChannel
        case pending
        case transactionId
        case transactionType
        case accountOwner
        case authorizedDate
        case authorizedDatetime
        case categoryId
        case checkNumber
        case counterparties
        case datetime
        case location
        case logoUrl
        case merchantEntityId
        case merchantName
        case paymentMeta
        case pendingTransactionId
        case personalFinanceCategory
        case personalFinanceCategoryIconUrl
        case transactionCode
        case unofficialCurrencyCode
        case website
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode required properties with fallbacks
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId) ?? ""
        amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        category = try container.decodeIfPresent([TransactionCategory].self, forKey: .category) ?? [.unknown]
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        isoCurrencyCode = try container.decodeIfPresent(String.self, forKey: .isoCurrencyCode) ?? "USD"
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        paymentChannel = try container.decodeIfPresent(PaymentChannel.self, forKey: .paymentChannel) ?? .unknown
        pending = try container.decodeIfPresent(Bool.self, forKey: .pending) ?? false
        transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId) ?? UUID().uuidString
        transactionType = try container.decodeIfPresent(TransactionType.self, forKey: .transactionType) ?? .unknown
        
        // Decode optional properties
        accountOwner = try container.decodeIfPresent(String.self, forKey: .accountOwner)
        authorizedDate = try container.decodeIfPresent(Date.self, forKey: .authorizedDate)
        authorizedDatetime = try container.decodeIfPresent(Date.self, forKey: .authorizedDatetime)
        categoryId = try container.decodeIfPresent(String.self, forKey: .categoryId)
        checkNumber = try container.decodeIfPresent(String.self, forKey: .checkNumber)
        counterparties = try container.decodeIfPresent([Counterparty].self, forKey: .counterparties)
        datetime = try container.decodeIfPresent(Date.self, forKey: .datetime)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        logoUrl = try container.decodeIfPresent(String.self, forKey: .logoUrl)
        merchantEntityId = try container.decodeIfPresent(String.self, forKey: .merchantEntityId)
        merchantName = try container.decodeIfPresent(String.self, forKey: .merchantName)
        paymentMeta = try container.decodeIfPresent(PaymentMeta.self, forKey: .paymentMeta)
        pendingTransactionId = try container.decodeIfPresent(String.self, forKey: .pendingTransactionId)
        personalFinanceCategory = try container.decodeIfPresent(PersonalFinanceCategory.self, forKey: .personalFinanceCategory)
        personalFinanceCategoryIconUrl = try container.decodeIfPresent(String.self, forKey: .personalFinanceCategoryIconUrl)
        transactionCode = try container.decodeIfPresent(String.self, forKey: .transactionCode)
        unofficialCurrencyCode = try container.decodeIfPresent(String.self, forKey: .unofficialCurrencyCode)
        website = try container.decodeIfPresent(String.self, forKey: .website)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode required properties
        try container.encode(accountId, forKey: .accountId)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
        try container.encode(isoCurrencyCode, forKey: .isoCurrencyCode)
        try container.encode(name, forKey: .name)
        try container.encode(paymentChannel, forKey: .paymentChannel)
        try container.encode(pending, forKey: .pending)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(transactionType, forKey: .transactionType)

        // Encode optional properties
        try container.encodeIfPresent(accountOwner, forKey: .accountOwner)
        try container.encodeIfPresent(authorizedDate, forKey: .authorizedDate)
        try container.encodeIfPresent(authorizedDatetime, forKey: .authorizedDatetime)
        try container.encodeIfPresent(categoryId, forKey: .categoryId)
        try container.encodeIfPresent(checkNumber, forKey: .checkNumber)
        try container.encodeIfPresent(counterparties, forKey: .counterparties)
        try container.encodeIfPresent(datetime, forKey: .datetime)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(logoUrl, forKey: .logoUrl)
        try container.encodeIfPresent(merchantEntityId, forKey: .merchantEntityId)
        try container.encodeIfPresent(merchantName, forKey: .merchantName)
        try container.encodeIfPresent(paymentMeta, forKey: .paymentMeta)
        try container.encodeIfPresent(pendingTransactionId, forKey: .pendingTransactionId)
        try container.encodeIfPresent(personalFinanceCategory, forKey: .personalFinanceCategory)
        try container.encodeIfPresent(personalFinanceCategoryIconUrl, forKey: .personalFinanceCategoryIconUrl)
        try container.encodeIfPresent(transactionCode, forKey: .transactionCode)
        try container.encodeIfPresent(unofficialCurrencyCode, forKey: .unofficialCurrencyCode)
        try container.encodeIfPresent(website, forKey: .website)
    }

    // Convenience initializer for mocking/testing
    convenience init(accountId: String,
                    amount: Double,
                    category: [TransactionCategory],
                    date: Date,
                    isoCurrencyCode: String,
                    name: String,
                    paymentChannel: PaymentChannel,
                    pending: Bool,
                    transactionId: String,
                    transactionType: TransactionType,
                    accountOwner: String? = nil,
                    authorizedDate: Date? = nil,
                    authorizedDatetime: Date? = nil,
                    categoryId: String? = nil,
                    checkNumber: String? = nil,
                    counterparties: [Counterparty]? = nil,
                    datetime: Date? = nil,
                    location: Location? = nil,
                    logoUrl: String? = nil,
                    merchantEntityId: String? = nil,
                    merchantName: String? = nil) {
        
        self.init(accountId: accountId,
                  amount: amount,
                  category: category,
                  date: date,
                  isoCurrencyCode: isoCurrencyCode,
                  name: name,
                  paymentChannel: paymentChannel,
                  pending: pending,
                  transactionId: transactionId,
                  transactionType: transactionType)
        
        self.accountOwner = accountOwner
        self.authorizedDate = authorizedDate
        self.authorizedDatetime = authorizedDatetime
        self.categoryId = categoryId
        self.checkNumber = checkNumber
        self.counterparties = counterparties
        self.datetime = datetime
        self.location = location
        self.logoUrl = logoUrl
        self.merchantEntityId = merchantEntityId
        self.merchantName = merchantName
    }
}

