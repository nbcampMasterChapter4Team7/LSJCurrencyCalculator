//
//  UIKit+.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
