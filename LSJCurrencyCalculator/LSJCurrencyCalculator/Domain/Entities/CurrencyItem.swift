//
//  CurrencyItem.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

enum RateChangeDirection: String, Codable {
    case up, down, none
}

struct CurrencyItem {
    let currencyCode: String
    let rate: Double
    var timeUnix: Int
    var change: RateChangeDirection
    var isFavorite: Bool
}
