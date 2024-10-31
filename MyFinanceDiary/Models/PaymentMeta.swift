import Foundation
import SwiftData

// MARK: - PaymentMeta

@Model
final class PaymentMeta: Codable {
    var byOrderOf: String?
    var payee: String?
    var payer: String?
    var paymentMethod: String?
    var paymentProcessor: String?
    var ppdId: String?
    var reason: String?
    var referenceNumber: String?

    enum CodingKeys: String, CodingKey {
        case byOrderOf
        case payee
        case payer
        case paymentMethod
        case paymentProcessor
        case ppdId
        case reason
        case referenceNumber
    }

    init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil,
         paymentMethod: String? = nil, paymentProcessor: String? = nil,
         ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
        self.byOrderOf = byOrderOf
        self.payee = payee
        self.payer = payer
        self.paymentMethod = paymentMethod
        self.paymentProcessor = paymentProcessor
        self.ppdId = ppdId
        self.reason = reason
        self.referenceNumber = referenceNumber
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.byOrderOf = try container.decodeIfPresent(String.self, forKey: .byOrderOf)
        self.payee = try container.decodeIfPresent(String.self, forKey: .payee)
        self.payer = try container.decodeIfPresent(String.self, forKey: .payer)
        self.paymentMethod = try container.decodeIfPresent(String.self, forKey: .paymentMethod)
        self.paymentProcessor = try container.decodeIfPresent(String.self, forKey: .paymentProcessor)
        self.ppdId = try container.decodeIfPresent(String.self, forKey: .ppdId)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.referenceNumber = try container.decodeIfPresent(String.self, forKey: .referenceNumber)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(byOrderOf, forKey: .byOrderOf)
        try container.encodeIfPresent(payee, forKey: .payee)
        try container.encodeIfPresent(payer, forKey: .payer)
        try container.encodeIfPresent(paymentMethod, forKey: .paymentMethod)
        try container.encodeIfPresent(paymentProcessor, forKey: .paymentProcessor)
        try container.encodeIfPresent(ppdId, forKey: .ppdId)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(referenceNumber, forKey: .referenceNumber)
    }
}
