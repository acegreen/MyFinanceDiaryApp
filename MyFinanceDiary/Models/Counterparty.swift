import Foundation

struct Counterparty: Codable {
    var confidenceLevel: String?
    var entityId: String?
    var logoUrl: String?
    var name: String
    var phoneNumber: String?
    var type: String
    var website: String?
    
    private enum CodingKeys: String, CodingKey {
        case confidenceLevel
        case entityId
        case logoUrl
        case name
        case phoneNumber
        case type
        case website
    }
}
