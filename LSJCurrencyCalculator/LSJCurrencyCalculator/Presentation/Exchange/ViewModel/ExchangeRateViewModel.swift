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
        case toggleFavorite(currencyCode: String)
    }

    // State 정의: View가 관찰할 상태 값
    struct State {
        var currencyItems: [CurrencyItem] = []
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
    private var allExchangeRates: [CurrencyItem] = []

    // UseCase 의존성
    private let currencyItemUseCase: CurrencyItemUseCase
    // 즐겨찾기 관련 UseCase (CoreData를 이용한 CRUD 기능을 포함)
    private let favoriteCurrencyUseCase: FavoriteCurrencyUseCase

    init(currencyItemUseCase: CurrencyItemUseCase, favoriteCurrencyUseCase: FavoriteCurrencyUseCase) {
        self.currencyItemUseCase = currencyItemUseCase
        self.favoriteCurrencyUseCase = favoriteCurrencyUseCase

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
        currencyItemUseCase.execute(base: base) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    let sortedRates = rates.sorted { $0.currencyCode < $1.currencyCode }
                    self?.allExchangeRates = sortedRates
                    self?.state.currencyItems = self?.applyFavoriteSorting(to: sortedRates) ?? []
                    self?.state.errorMessage = nil
                case .failure:
                    self?.allExchangeRates = []
                    self?.state.currencyItems = []
                    self?.state.errorMessage = "데이터를 불러올 수 없습니다."
                }
            }
        }
    }

    // 검색어를 전달받아 환율 데이터를 필터링하는 함수
    func filterRates(with searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filteredRates: [CurrencyItem]
        if trimmed.isEmpty {
            // 검색어가 비어있으면 전체 데이터 노출
            filteredRates = allExchangeRates
        } else {
            let uppercasedSearch = trimmed.uppercased()
            filteredRates = allExchangeRates.filter { rate in
                return rate.currencyCode.contains(uppercasedSearch)
                    || CurrencyCountryMapper.countryName(for: rate.currencyCode).contains(uppercasedSearch)
            }
        }
        // 필터링 결과에도 즐겨찾기 정렬 적용
        state.currencyItems = applyFavoriteSorting(to: filteredRates)
    }

    // 즐겨찾기 토글 처리 함수
     private func toggleFavorite(for currencyCode: String) {
        do {
            try favoriteCurrencyUseCase.toggleFavorite(currencyCode: currencyCode)
        } catch {
            state.errorMessage = "즐겨찾기 변경에 실패했습니다."
        }
        // 즐겨찾기 상태가 변경되었으므로, 전체 데이터를 즐겨찾기 상태에 맞게 재정렬
        state.currencyItems = applyFavoriteSorting(to: allExchangeRates)
    }


    // 즐겨찾기 상태 반영 정렬 함수:
    // 즐겨찾기된 항목은 상단에 오고, 같은 그룹 내에서는 알파벳 순 정렬
     private func applyFavoriteSorting(to rates: [CurrencyItem]) -> [CurrencyItem] {
        return rates.sorted { left, right in
            let leftFav = favoriteCurrencyUseCase.isFavorite(currencyCode: left.currencyCode)
            let rightFav = favoriteCurrencyUseCase.isFavorite(currencyCode: right.currencyCode)
            if leftFav != rightFav {
                return leftFav && !rightFav
            }
            return left.currencyCode < right.currencyCode
        }
    }
    
    func isFavorite(currencyCode: String) -> Bool {
        return favoriteCurrencyUseCase.isFavorite(currencyCode: currencyCode)
    }

}

