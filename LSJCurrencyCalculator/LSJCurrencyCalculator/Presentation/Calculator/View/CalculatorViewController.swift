//
//  CalculatorViewController.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import UIKit

import SnapKit
import Then

final class CalculatorViewController: UIViewController {
    
    // MARK: - Properties

    private let viewModel: CalculatorViewModel
    
    // MARK: - UI Components

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .text
    }

    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryText
    }

    private let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "달러(USD)를 입력하세요"
    }

    private let convertButton = UIButton().then {
        $0.backgroundColor = .button
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitle("환율 계산", for: .normal)
    }

    private let resultLabel = UILabel().then {
        $0.text = "계산 결과가 여기에 표시됩니다"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .text
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    // MARK: - Initializer
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    
    // MARK: - LifeCycle - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setLayout()
        configure()
        bindViewModel()

        // 환율 계산 버튼을 눌렀을 때 행동 처리
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        viewModel.action?(.saveLastViewItem)
    }
    
    // MARK: - Style

    private func setStyle() {
        view.backgroundColor = .background
        navigationItem.title = "환율 계산기"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Layout

    private func setLayout() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        view.addSubviews(labelStackView, amountTextField, convertButton, resultLabel)

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    // MARK: - @objc Methods
    
    @objc private func convertButtonTapped() {
        // 텍스트필드의 값을 가져와 Action 전달
        guard let input = amountTextField.text else { return }
        viewModel.action?(.convertCurrency(input))
    }

    // MARK: - Methods
    
    // MARK: - Methods - bindViewModel
    /// 상태 업데이트에 따라 결과 출력, 에러가 있으면 Alert 처리
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                if let error = state.errorMessage {
                    self?.showAlert(message: error)
                }
                if let result = state.conversionResult {
                    self?.resultLabel.text = "$\(state.inputAmount) → \(result) \(state.conversionCurrency)"
                }
            }
        }
    }

    // MARK: - Methods - showAlert

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Configure
    
    private func configure() {
        let exchangeRate = viewModel.selectedCurrencyItem
        currencyLabel.text = exchangeRate.currencyCode
        countryLabel.text = CurrencyCountryMapper.countryName(for: exchangeRate.currencyCode)
    }
}
