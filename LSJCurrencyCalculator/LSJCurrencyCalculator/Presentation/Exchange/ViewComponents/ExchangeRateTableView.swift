//
//  ExchangeRateTableView.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit

import SnapKit
import Then

final class ExchangeRateTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: ExchangeRateTableViewCell.identifier)
        self.rowHeight = 50
        self.separatorStyle = .singleLine
    }
}

