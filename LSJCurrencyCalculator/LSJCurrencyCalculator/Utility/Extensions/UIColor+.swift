//
//  UIColor+.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import Foundation
import UIKit

extension UIColor {
    static func asset(_ asset: Asset) -> UIColor {
        guard let color = UIColor(named: asset.rawValue) else {
            fatalError("Color asset '\(asset.rawValue)' not found in Asset Catalog")
        }
        return color
    }
    enum Asset: String {
        case backgroundColor = "BackgroundColor"
        case textColor = "TextColor"
        case secondaryTextColor = "SecondaryTextColor"
        case cellBackgroundColor = "CellBackgroundColor"
        case favoriteColor = "FavoriteColor"
        case buttonColor = "ButtonColor"
    }
}
