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
        case filterRates(searchText: String) // 필터링 액션 추가
        case toggleFavorite(currency: String)
    }

    // State 정의: View가 관찰할 상태 값
    struct State {
        var exchangeRates: [ExchangeRate] = []
        var errorMessage: String?
    }

    // 프로토콜 요구사항
    var action: ((Action) -> Void)?
    // State 변경 시 ViewController에서 상태를 관찰할 수 있도록 제공
    var onStateChange: ((State) -> Void)?

    private(set) var state = State() {
        didSet {
            self.onStateChange?(state)
        }
    }

    // 전체 데이터를 보관하기 위한 프로퍼티 (필터링 용)
    private var allExchangeRates: [ExchangeRate] = []

    // UseCase 의존성
    private let fetchExchangeRateUseCase: FetchExchangeRateUseCase
    // 즐겨찾기 관련 UseCase (CoreData를 이용한 CRUD 기능을 포함)
    private let manageFavoriteUseCase: ManageFavoriteUseCase
    
    init(fetchExchangeRateUseCase: FetchExchangeRateUseCase, manageFavoriteUseCase: ManageFavoriteUseCase ) {
        self.fetchExchangeRateUseCase = fetchExchangeRateUseCase
        self.manageFavoriteUseCase = manageFavoriteUseCase

        // action 클로저 구현
        self.action = { [weak self] action in
            switch action {
            case .fetchRates(let base):
                self?.fetchRates(base: base)
            case .filterRates(let searchText):
                self?.filterRates(with: searchText)
            case .toggleFavorite(let currency):
                self?.toggleFavorite(for: currency)
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
    
    // 즐겨찾기 토글 처리 함수
    private func toggleFavorite(for currency: String) {
        guard let rate = allExchangeRates.first(where: { $0.currency == currency })?.rate else { return }

        do {
            try manageFavoriteUseCase.toggleFavorite(currency: currency, rate: rate)
        } catch {
            state.errorMessage = "즐겨찾기 변경에 실패했습니다."
        }
        // 즐겨찾기 상태가 변경되었으므로, 전체 데이터를 즐겨찾기 상태에 맞게 재정렬
        state.exchangeRates = applyFavoriteSorting(to: allExchangeRates)
    }

    
    // 즐겨찾기 상태 반영 정렬 함수:
    // 즐겨찾기된 항목은 상단에 오고, 같은 그룹 내에서는 알파벳 순 정렬
    private func applyFavoriteSorting(to rates: [ExchangeRate]) -> [ExchangeRate] {
        return rates.sorted { left, right in
            let leftFav = manageFavoriteUseCase.isFavorite(currency: left.currency)
            let rightFav = manageFavoriteUseCase.isFavorite(currency: right.currency)
            if leftFav != rightFav {
                return leftFav && !rightFav
            }
            return left.currency < right.currency
        }
    }
}

