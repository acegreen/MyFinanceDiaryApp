import Foundation

extension Decimal {
    func isLessThan(_ other: Decimal) -> Bool {
        return self < other
    }
    
    func isGreaterThan(_ other: Decimal) -> Bool {
        return self > other
    }
    
    func isEqualTo(_ other: Decimal) -> Bool {
        return self == other
    }
}
