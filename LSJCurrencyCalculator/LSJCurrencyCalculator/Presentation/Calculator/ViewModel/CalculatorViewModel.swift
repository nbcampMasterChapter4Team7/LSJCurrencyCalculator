//
//  CalculatorViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import Foundation

final class CalculatorViewModel: ViewModelProtocol {

    // MARK: - Properties
    
    enum Action {
        case convertCurrency(String)
        case saveLastViewItem
    }

    struct State {
        var conversionResult: String? = nil
        var inputAmount: String = ""
        var conversionCurrency: String = ""
        var errorMessage: String? = nil
    }

    var onStateChange: ((State) -> Void)?

    var action: ((Action) -> Void)?

    private(set) var state: State = State() {
        didSet {
            onStateChange?(state)
        }
    }

    // 선택한 환율 정보 저장
    let selectedCurrencyItem: CurrencyItem
    
    // MARK: Proterties - UseCase
    
    private let lastViewItemUseCase: LastViewItemUseCase

    
    // MARK: - Initializer
    
    init(selectedCurrencyItem: CurrencyItem, lastViewItemUseCase: LastViewItemUseCase) {
        self.selectedCurrencyItem = selectedCurrencyItem
        self.lastViewItemUseCase = lastViewItemUseCase

        self.action = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .convertCurrency(let input):
                self.convert(input: input)
            case .saveLastViewItem:
                self.saveLastView()
            }
        }
    }

    // MARK: - Methods
    
    // MARK: - Methods - convert
    
    /// Description
    /// - Parameter input: 환율 정보 얻기 위한 입력 데이터
    /// 변환 로직: 입력값 검증 후 비동기 API 호출(시뮬레이션)
    private func convert(input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // 빈 문자열 검증
        if trimmed.isEmpty {
            state.errorMessage = "금액을 입력해주세요"
            state.conversionResult = nil
            return
        }

        // 숫자로 변환 가능한지 검증
        guard let amount = Double(trimmed) else {
            state.errorMessage = "올바른 숫자를 입력해주세요"
            state.conversionResult = nil
            return
        }

        // 에러 메시지 초기화
        state.errorMessage = nil

        // API 호출 시뮬레이션 (비동기 처리)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            // 계산: 입력 금액 * 선택된 환율의 rate
            let result = amount * self.selectedCurrencyItem.rate
            // 소수점 둘째자리로 반올림
            let rounded = (result * 100).rounded() / 100
            let resultText = String(format: "%.2f", rounded)
            DispatchQueue.main.async {
                self.state.inputAmount = String(format: "%.2f", amount)
                self.state.conversionResult = resultText
                self.state.conversionCurrency = self.selectedCurrencyItem.currencyCode
            }
        }
    }
    
    // MARK: - Methods - saveLastViewItem
    
    /// 마지막으로 본 화면 저장
    private func saveLastView() {
        let lastViewItem = LastViewItem(screenType: .calculator, currencyCode: selectedCurrencyItem.currencyCode)
        try? lastViewItemUseCase.saveLastViewItem(lastViewItem: lastViewItem)
    }
}
