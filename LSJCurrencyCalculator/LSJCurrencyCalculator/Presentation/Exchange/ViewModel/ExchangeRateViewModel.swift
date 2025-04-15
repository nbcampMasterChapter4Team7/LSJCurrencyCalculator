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
        case filterRates(searchText: String)  // 필터링 액션 추가
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
    
    // 전체 데이터를 보관하기 위한 프로퍼티 (필터링 용)
     private var allExchangeRates: [ExchangeRate] = []

    // UseCase 의존성
    private let fetchExchangeRateUseCase: FetchExchangeRateUseCase
    
    init(useCase: FetchExchangeRateUseCase) {
        self.fetchExchangeRateUseCase = useCase

        // action 클로저 구현
        self.action = { [weak self] action in
            switch action {
            case .fetchRates(let base):
                self?.fetchRates(base: base)
            case .filterRates(let searchText):
                self?.filterRates(with: searchText)
            }
        }
    }

    // 실제 데이터를 불러오는 함수
    private func fetchRates(base: String) {
        fetchExchangeRateUseCase.execute(base: base) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    let sortedRates = rates.sorted { $0.currency < $1.currency }
                    self?.allExchangeRates = sortedRates
                    self?.state.exchangeRates = sortedRates
                    self?.state.errorMessage = nil
                case .failure:
                    self?.allExchangeRates = []
                    self?.state.exchangeRates = []
                    self?.state.errorMessage = "데이터를 불러올 수 없습니다."
                }
            }
        }
    }
    
    // 검색어를 전달받아 환율 데이터를 필터링하는 함수
    func filterRates(with searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            // 검색어가 비어있으면 전체 데이터 노출
            state.exchangeRates = allExchangeRates
        } else {
            let uppercasedSearch = trimmed.uppercased()
            state.exchangeRates = allExchangeRates.filter { rate in
                // 통화 코드 혹은 국가명(CurrencyCountryMapper를 통한 변환)을 기준으로 필터링
                return rate.currency.contains(uppercasedSearch)
                || CurrencyCountryMapper.countryName(for: rate.currency).contains(uppercasedSearch)
            }
        }
    }
}

