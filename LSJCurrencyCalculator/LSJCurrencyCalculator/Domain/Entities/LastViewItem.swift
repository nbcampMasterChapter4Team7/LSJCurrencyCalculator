//
//  LastViewItem.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

enum ScreenType: String, Codable {
    case exchange
    case calculator
}

struct LastViewItem {
    let screenType: ScreenType
    let currencyCode: String?
}
