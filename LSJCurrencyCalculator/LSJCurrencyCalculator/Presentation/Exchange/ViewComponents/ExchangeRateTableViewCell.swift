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

    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
    }

    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }


    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
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
        countryLabel.text = CurrencyCountryMapper.countryName(for: currency)
        rateLabel.text = String(format: "%.4f", rate)
    }

    private func setupLayout() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        contentView.addSubviews(labelStackView, rateLabel)

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.width.equalTo(120)
        }
    }
}

