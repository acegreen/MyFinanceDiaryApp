import Foundation
import SwiftData

@Model
final class PersonalFinanceCategory: Codable {
    var confidenceLevel: String
    var detailed: String
    var primary: String
    
    init(confidenceLevel: String = "", detailed: String = "", primary: String = "") {
        self.confidenceLevel = confidenceLevel
        self.detailed = detailed
        self.primary = primary
    }
    
    private enum CodingKeys: String, CodingKey {
        case confidenceLevel
        case detailed
        case primary
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.confidenceLevel = try container.decode(String.self, forKey: .confidenceLevel)
        self.detailed = try container.decode(String.self, forKey: .detailed)
        self.primary = try container.decode(String.self, forKey: .primary)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(confidenceLevel, forKey: .confidenceLevel)
        try container.encode(detailed, forKey: .detailed)
        try container.encode(primary, forKey: .primary)
    }
} 
