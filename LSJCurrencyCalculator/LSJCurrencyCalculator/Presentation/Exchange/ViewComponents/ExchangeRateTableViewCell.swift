//
//  ExchangeRateTableViewCell.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//


import UIKit

import SnapKit
import Then

final class ExchangeRateTableViewCell: UITableViewCell {

    static let identifier = "ExchangeRateCell"

    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }

    // 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 셀에 데이터 설정
    func configure(with currency: String, rate: Double) {
        currencyLabel.text = currency
        rateLabel.text = String(format: "%.4f", rate)
    }

    private func setupLayout() {
        contentView.addSubview(currencyLabel)
        contentView.addSubview(rateLabel)

        currencyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}

