import Foundation

enum TransactionType: String, Codable {
    case special
    case place
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = TransactionType(rawValue: rawValue) ?? .unknown
    }
}
