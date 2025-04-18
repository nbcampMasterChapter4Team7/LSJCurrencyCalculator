//
//  LastViewItem.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

enum ScreenType {
    case exchange
    case caculator
}

struct LastViewItem {
    let screenType: ScreenType
    let currencyCode: String
}
