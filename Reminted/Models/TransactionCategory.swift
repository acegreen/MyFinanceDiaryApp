import Foundation

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
    case insurance = "Insurance"
    case entertainment = "Entertainment"
    case creditCard = "Credit Card"
    case deposit = "Deposit"
    case payroll = "Payroll"
    case taxi = "Taxi"
    case fastFood = "Fast Food"
    case coffeeShop = "Coffee Shop"
    case airlinesAndAviation = "Airlines and Aviation Services"
    case sportingGoods = "Sporting Goods"
    case shops = "Shops"
    case gymsAndFitnessCenters = "Gyms and Fitness Centers"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        // Try to create from exact match first
        if let category = TransactionCategory(rawValue: rawValue) {
            self = category
        } else {
            // Map similar categories if possible
            switch rawValue.lowercased() {
                case let str where str.contains("food") || str.contains("drink"):
                    self = .foodAndDrink
                case let str where str.contains("restaurant"):
                    self = .restaurants
                case let str where str.contains("transport"):
                    self = .transportation
                case let str where str.contains("entertain"):
                    self = .entertainment
                case let str where str.contains("credit card"):
                    self = .creditCard
                case let str where str.contains("deposit"):
                    self = .deposit
                case let str where str.contains("payroll"):
                    self = .payroll
                case let str where str.contains("taxi"):
                    self = .taxi
                case let str where str.contains("fast food"):
                    self = .fastFood
                case let str where str.contains("coffee"):
                    self = .coffeeShop
                case let str where str.contains("airline") || str.contains("aviation"):
                    self = .airlinesAndAviation
                case let str where str.contains("gym") || str.contains("fitness"):
                    self = .gymsAndFitnessCenters
                case let str where str.contains("sporting"):
                    self = .sportingGoods
                default:
                    self = .unknown
            }
        }
    }
} 
