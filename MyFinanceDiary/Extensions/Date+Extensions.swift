//
//  Date+Extensions.swift
//  MyFinanceDiary
//
//  Created by Ace Green on 2024-10-30.
//

import Foundation

extension DateFormatter {
    static let plaidDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
