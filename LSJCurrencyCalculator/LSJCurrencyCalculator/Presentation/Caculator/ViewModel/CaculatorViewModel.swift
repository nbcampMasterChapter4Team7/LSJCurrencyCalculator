//
//  CaculatorViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import Foundation

final class CaculatorViewModel: ViewModelProtocol {

    // Action 정의: 사용자가 입력하거나 버튼을 누를 때 발생하는 이벤트
    enum Action {
        case convertCurrency(String)  // 버튼 클릭 시, 입력값을 바탕으로 변환 요청
    }
    
    // State 정의: 계산기에 필요한 상태 값들
    struct State {
        var conversionResult: String? = nil
        var inputAmount: String = ""
        var conversionCurrency: String = ""
        var errorMessage: String? = nil
    }
    
    // 상태 변경 콜백
    var onStateChange: ((State) -> Void)?
    
    // Action 호출용 클로저
    var action: ((Action) -> Void)?
    
    // 현재 상태. didSet으로 상태 변경시 onStateChange 호출.
    private(set) var state: State = State() {
        didSet {
            onStateChange?(state)
        }
    }
    
    // 선택한 환율 정보를 저장합니다.
    let selectedCurrencyItem: CurrencyItem

    // 초기화 시 선택한 환율 정보를 받습니다.
    init(selectedCurrencyItem: CurrencyItem) {
        self.selectedCurrencyItem = selectedCurrencyItem
        
        // Action 클로저 구현: 각 액션에 따른 처리
        self.action = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .convertCurrency(let input):
                self.convert(input: input)
            }
        }
    }
    
    // 변환 로직: 입력값 검증 후 비동기 API 호출(시뮬레이션)
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
}
