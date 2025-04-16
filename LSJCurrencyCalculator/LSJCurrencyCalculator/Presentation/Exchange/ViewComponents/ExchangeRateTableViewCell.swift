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

    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .systemYellow
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    // 즐겨찾기 버튼 클릭 시 외부에서 처리할 클로저
    var favoriteButtonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapFavorite() {
        favoriteButtonAction?()
    }

    // 즐겨찾기 상태에 따라 버튼 이미지 업데이트
    func configure(with currency: String, rate: Double, isFavorite: Bool) {
        currencyLabel.text = currency
        countryLabel.text = CurrencyCountryMapper.countryName(for: currency)
        rateLabel.text = String(format: "%.4f", rate)
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func setupLayout() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        contentView.addSubviews(labelStackView, rateLabel, favoriteButton)

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.width.equalTo(120)
        }
    }
}
