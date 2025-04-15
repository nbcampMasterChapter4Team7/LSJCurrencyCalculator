//
//  ExchangeRateViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//


import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {

    // Action 정의: ViewModel에 요청할 수 있는 작업
    enum Action {
        case fetchRates(base: String)
    }

    // State 정의: View가 관찰할 상태 값
    struct State {
        var exchangeRates: [ExchangeRate] = []
        var errorMessage: String?
    }

    // 프로토콜 요구사항
    var action: ((Action) -> Void)?

    private(set) var state = State() {
        didSet {
            self.onStateChange?(state)
        }
    }
    
    // State 변경 시 ViewController에서 상태를 관찰할 수 있도록 제공
    var onStateChange: ((State) -> Void)?

    // UseCase 의존성
    private let fetchExchangeRateUseCase: FetchExchangeRateUseCase
    
    init(useCase: FetchExchangeRateUseCase) {
        self.fetchExchangeRateUseCase = useCase

        // action 클로저 구현
        self.action = { [weak self] action in
            switch action {
            case .fetchRates(let base):
                self?.fetchRates(base: base)
            }
        }
    }

    // 실제 데이터를 불러오는 함수
    private func fetchRates(base: String) {
        fetchExchangeRateUseCase.execute(base: base) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    self?.state.exchangeRates = rates
                    self?.state.errorMessage = nil
                case .failure:
                    self?.state.exchangeRates = []
                    self?.state.errorMessage = "데이터를 불러올 수 없습니다."
                }
            }
        }
    }
}

