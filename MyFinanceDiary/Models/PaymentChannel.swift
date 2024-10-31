import Foundation

enum PaymentChannel: String, Codable, CaseIterable {
    case inStore = "in store"
    case online = "online"
    case unknown = "unknown"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = PaymentChannel(rawValue: rawValue) ?? .unknown
    }
}
