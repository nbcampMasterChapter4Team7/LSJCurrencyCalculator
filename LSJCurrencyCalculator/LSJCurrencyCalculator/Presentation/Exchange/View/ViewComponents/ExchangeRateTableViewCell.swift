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

    // MARK: - Properties
    
    static let identifier = "ExchangeRateCell"
    
    // MARK: - UI Components

    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .text
    }

    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .secondaryText
    }

    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .text
        $0.textAlignment = .right
    }

    private let trendLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }

    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .favorite
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setLayout()
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Style
    
    private func setStyle() {
        contentView.backgroundColor = .cellBackground
    }
    
    // MARK: - Layout

    private func setLayout() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        contentView.addSubviews(labelStackView, rateLabel, trendLabel, favoriteButton)

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }


        rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(trendLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.width.equalTo(120)
        }

        trendLabel.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

    }

    // MARK: Actions
    // 즐겨찾기 버튼 클릭 시 외부에서 처리할 클로저
    var favoriteButtonAction: (() -> Void)?

    // MARK: - @objc Methods
    
    @objc private func didTapFavorite() {
        favoriteButtonAction?()
    }
    
    // MARK: - Configure
    /// 즐겨찾기 상태에 따라 버튼 이미지 업데이트
    func configure(with currency: String, rate: Double, direction: RateChangeDirection, isFavorite: Bool) {
        currencyLabel.text = currency
        countryLabel.text = CurrencyCountryMapper.countryName(for: currency)
        rateLabel.text = String(format: "%.4f", rate)
        switch direction {
        case .up:
            trendLabel.text = "🔼"
        case .down:
            trendLabel.text = "🔽"
        case .none:
            trendLabel.text = "―"
        }
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
