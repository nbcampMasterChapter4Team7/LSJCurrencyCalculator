//
//  ExchangeRateSearchBar.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import UIKit

import SnapKit
import Then

final class ExchangeRateSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.placeholder = "통화 검색"
        self.backgroundImage = UIImage() // 검색바 위/아래 테두리 제거
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
