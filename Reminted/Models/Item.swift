import SwiftData
import Foundation

@Model
final class Item: Codable {
    var availableProducts: [String]
    var billedProducts: [String]
    var consentExpirationTime: Date?
    var consentedProducts: [String]
    var error: String?
    var institutionId: String
    var itemId: String
    var products: [String]
    var updateType: String
    var webhook: String
    
    @Relationship(inverse: \Provider.item) var provider: Provider?
    
    init(availableProducts: [String] = [],
         billedProducts: [String] = [],
         consentExpirationTime: Date? = nil,
         consentedProducts: [String] = [],
         error: String? = nil,
         institutionId: String = "",
         itemId: String = "",
         products: [String] = [],
         updateType: String = "",
         webhook: String = "") {
        self.availableProducts = availableProducts
        self.billedProducts = billedProducts
        self.consentExpirationTime = consentExpirationTime
        self.consentedProducts = consentedProducts
        self.error = error
        self.institutionId = institutionId
        self.itemId = itemId
        self.products = products
        self.updateType = updateType
        self.webhook = webhook
    }
    
    private enum CodingKeys: String, CodingKey {
        case availableProducts
        case billedProducts
        case consentExpirationTime
        case consentedProducts
        case error
        case institutionId
        case itemId
        case products
        case updateType
        case webhook
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(
            availableProducts: try container.decodeIfPresent([String].self, forKey: .availableProducts) ?? [],
            billedProducts: try container.decodeIfPresent([String].self, forKey: .billedProducts) ?? [],
            consentExpirationTime: try container.decodeIfPresent(Date.self, forKey: .consentExpirationTime),
            consentedProducts: try container.decodeIfPresent([String].self, forKey: .consentedProducts) ?? [],
            error: try container.decodeIfPresent(String.self, forKey: .error),
            institutionId: try container.decodeIfPresent(String.self, forKey: .institutionId) ?? "",
            itemId: try container.decodeIfPresent(String.self, forKey: .itemId) ?? "",
            products: try container.decodeIfPresent([String].self, forKey: .products) ?? [],
            updateType: try container.decodeIfPresent(String.self, forKey: .updateType) ?? "",
            webhook: try container.decodeIfPresent(String.self, forKey: .webhook) ?? ""
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(availableProducts, forKey: .availableProducts)
        try container.encode(billedProducts, forKey: .billedProducts)
        try container.encodeIfPresent(consentExpirationTime, forKey: .consentExpirationTime)
        try container.encode(consentedProducts, forKey: .consentedProducts)
        try container.encodeIfPresent(error, forKey: .error)
        try container.encode(institutionId, forKey: .institutionId)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(products, forKey: .products)
        try container.encode(updateType, forKey: .updateType)
        try container.encode(webhook, forKey: .webhook)
    }
}
