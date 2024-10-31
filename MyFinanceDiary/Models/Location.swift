import Foundation
import SwiftData

@Model
final class Location: Codable {
    var address: String?
    var city: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    var postalCode: String?
    var region: String?
    var storeNumber: String?
    
    init(address: String? = nil,
         city: String? = nil,
         country: String? = nil,
         lat: Double? = nil,
         lon: Double? = nil,
         postalCode: String? = nil,
         region: String? = nil,
         storeNumber: String? = nil) {
        self.address = address
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
        self.postalCode = postalCode
        self.region = region
        self.storeNumber = storeNumber
    }

    var coordinates: (latitude: Double, longitude: Double)? {
        #if DEBUG
        // Always return mock coordinates in debug
        return (45.5017, -73.5673)
        #else
        guard let lat = lat, let lon = lon else { return nil }
        return (lat, lon)
        #endif
    }
    
    private enum CodingKeys: String, CodingKey {
        case address
        case city
        case country
        case lat
        case lon
        case postalCode
        case region
        case storeNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon)
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.storeNumber = try container.decodeIfPresent(String.self, forKey: .storeNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(lat, forKey: .lat)
        try container.encodeIfPresent(lon, forKey: .lon)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(region, forKey: .region)
        try container.encodeIfPresent(storeNumber, forKey: .storeNumber)
    }
} 
