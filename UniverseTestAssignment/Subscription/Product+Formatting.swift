//
//  Product+Formatting.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import StoreKit

extension Product {
    func formatPeriod(value: Int, unit: String) -> String {
        "\(value) \(unit)\(value > 1 ? "s" : "")"
    }
}

extension Product.SubscriptionPeriod.Unit {
    var description: String {
        switch self {
        case .day: "day"
        case .week: "week"
        case .month: "month"
        case .year: "year"
        default: "period"
        }
    }
}
