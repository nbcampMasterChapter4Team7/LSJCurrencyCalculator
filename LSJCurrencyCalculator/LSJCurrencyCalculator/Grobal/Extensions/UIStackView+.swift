//
//  UIStackView_.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
