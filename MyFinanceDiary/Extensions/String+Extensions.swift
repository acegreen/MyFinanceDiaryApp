//
//  String+Extensions.swift
//  MyFinanceDiary
//
//  Created by Ace Green on 2024-10-29.
//

import Foundation

// Helper extension for date conversion
extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
